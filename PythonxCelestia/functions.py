#!/usr/bin/python

import Miscellaneous as misc
import imp
import time
import wx
import DatabaseParser as dbp
import EntityWorkspaceParser as ewp
import EditorWorkspaceParser as edwp
import SearchWorkspaceParser as swp

MainFrame = None

class ClassMapper:
	Map = misc.ClassMapper().Map

'''
	These are top level functions primarily for parsing the entities and attributes
'''

def GetEntityList(filename):
	l = list()
	f = open(filename, 'r')
	lines = f.readlines()
	for line in lines:
		betterLine = line.strip()
		if betterLine.startswith('class'):
			l.append(betterLine[6:-1])
	return l

def GetAttributeList(filepath, filename):
	entityList = GetEntityList(filepath)
	attributeList = list()
	for entity in entityList:
		ref = getattr(imp.load_source(filename[0:-3], filepath), entity)()
		for attribute in ref.Attributes:
			attributeList.append(entity + '.' + attribute)
	return attributeList

def GetTargets(filename, filepath):
	targets = list()
	entityList = GetEntityList(filepath)
	project = GetProject(entityList, filename, filepath)
	for entityWorkspace in project['lstProfile'][0]['lstEntity Workspace']:
		targets.append(entityWorkspace['sEntity Workspace Name'])
	for searchWorkspace in project['lstProfile'][0]['lstSearch Workspace']:
		targets.append(searchWorkspace['sSearch Workspace Name'])
	for editorWorkspace in project['lstProfile'][0]['lstEditor Workspace']:
		targets.append(editorWorkspace['sEditor Workspace Name'])
	for graph in project['lstProfile'][0]['lstGraph']:
		targets.append(graph['sGraph Name'])
	for viewWorkspace in project['lstProfile'][0]['lstView Workspace']:
		targets.append(viewWorkspace['sView Workspace Name'])
	for report in project['lstProfile'][0]['lstReport']:
		targets.append(report['sReport Name'])
	targets.extend(('PREF:', 'DASH:', '-:', 'LOG_OFF:', 'EXIT:', 'THM:', 'FONT:', 'ABT:', 'HLP:', 'MAIL_WORKSPACE : '))
	return targets
	
def GetProject(entityList, filename, filepath):
	MainFrame.SetStatusText('Parsing the source file to generate the project. This might take a while')
	project = {'sProject Name':'Project1', 'sSource File':filepath, 'sOutput Directory':'.', 'Database Properties':None, 'lstProfile':list(), 'Rendering Properties':{'sForm Rendering':'Render Single Page forms'}, 'lstDatabase Table':list()}
	project['lstProfile'].append(GetProfile(entityList, filename, filepath))
	for table in project['lstProfile'][0]['lstDatabase Table']:
		project['lstDatabase Table'].append(table)
	return GiveName(project)
	pass

def GetProfile(entityList, filename, filepath):
	# This function would return the dictionary of all components that could be generated using all these components
	# This function would return a dictionary of:
	# a) Entity Workspaces
	# b) Search Workspaces
	# c) Editor Workspaces
	# d) View Workspaces
	# e) Graphs
	# f) Reports
	# g) Printable Reports
	# h) Navigation
	profile = {'sProfile Name':'Default Profile', 'sOutput Directory':'.', 'lstMenu':list(), 'lstEntity Workspace':list(), 'lstGraph':list(), 'lstSearch Workspace':list(), 'lstView Workspace':list(), 'lstReport':list(), 'lstDatabase Table':list()}
	profile['lstEntity Workspace'] = ewp.GetAllEntityWorkspaces(entityList, filename, filepath)
	profile['lstEditor Workspace'] = edwp.GetAllEditorWorkspaces(entityList, filename, filepath)
	profile['lstSearch Workspace'] = swp.GetAllSearchWorkspaces(entityList, filename, filepath)
	profile['lstView Workspace'] = GetAllViewWorkspaces(entityList, filename, filepath)
	profile['lstGraph'] = GetAllGraphs(entityList, filename, filepath)
	profile['lstReport'] = GetAllReports(entityList, filename, filepath)
	profile['lstMenu'] = GetNavigation(entityList, filename, filepath)
	for table in dbp.GetDatabaseTables(entityList, filename, filepath):
		profile['lstDatabase Table'].append(table)
	return GiveName(profile)
	pass


#################################################################################################

#				     Graphs Workspace space					#

#################################################################################################

def GetAllGraphs(entityList, filename, filepath):
	graphs = list()
	for entity in entityList:
		ref = getattr(imp.load_source(filename[0:-3], filepath), entity)()
		graphs.append(GetGraph(ref, entity))
	return graphs

def GetGraph(ref, entity):
	graph = {'sGraph Name':entity, 'sEntity Name':entity, 'sSQL Statement':'', 'sX-Axis Column Name':'', 'sY-Axis Column Name':'', 'sType of Graph':''}
	return GiveName(graph)

#################################################################################################

#				     Report Workspace space					#

#################################################################################################

def GetAllReports(entityList, filename, filepath):
	reports = list()
	for entity in entityList:
		cls = getattr(imp.load_source(filename[0:-3], filepath), entity)()
		reports.append(GetReport(cls, entity))
	return reports

def GetReport(ref, entity):
	report = {'sReport Name':entity, 'sSQL Statement':'SELECT * FROM ' + entity, 'iRecords Per Page':0, 'lstAction':list()}
	report['lstAction'].append(GiveName({'sLabel':'&Edit', 'sAction':'Edit', 'sTarget':'EDITOR_WORKSPACE:' + entity, 'sMnemonic':'E'}))
	report['lstAction'].append(GiveName({'sLabel':'&View', 'sAction':'View', 'sTarget':'VIEW_WORKSPACE:' + entity, 'sMnemonic':'V'}))
	report['lstAction'].append(GiveName({'sLabel':'&Delete', 'sAction':'Delete', 'sTarget':'-:', 'sMnemonic':'D'}))
	report['lstAction'].append(GiveName({'sLabel':'&Send EMail', 'sAction':'Send EMail', 'sTarget':'MAIL_WORKSPACE : ', 'sMnemonic':'S'}))
	return GiveName(report)

#################################################################################################

#				     View Workspace space					#

#################################################################################################

def GetAllViewWorkspaces(entityList, filename, filepath):
	viewWorkspaces = list()
	for entity in entityList:
		cls = getattr(imp.load_source(filename[0:-3], filepath), entity)
		viewWorkspace = {'sView Workspace Name':entity, 'sEntity Name':entity, 'lstView Form':list(), 'lstView Object List':list(), 'lstView Simple List':list()}
		entityPropertiesForm = GetGenericViewForm(cls(), entity)
		viewWorkspace['lstView Form'].append(entityPropertiesForm)
		genericForms = GetGenericViewForms(cls(), entity, filename, filepath)
		for genericForm in genericForms:
			viewWorkspace['lstView Form'].append(genericForm)
		if GetViewSimpleLists(cls(), entity, filename, filepath) != None:
			viewWorkspace['lstView Simple List'] = GetViewSimpleLists(cls(), entity, filename, filepath)
		if GetViewObjectLists(cls(), entity, filename, filepath) != None:
			viewWorkspace['lstView Object List'] = GetViewObjectLists(cls(), entity, filename, filepath)
		viewWorkspaces.append(GiveName(viewWorkspace))
	return viewWorkspaces

def GetGenericViewForms(ref, entity, filename, filepath):
	genericViewForms = list()
	for attribute in ref.Attributes:
		if not(attribute.startswith('e') or attribute.startswith('s') or attribute.startswith('i') or attribute.startswith('b') or attribute.startswith('f') or attribute.startswith('d') or attribute.startswith('lst') or attribute.startswith('arr') or attribute.startswith('dct')):
			newClass = getattr(imp.load_source(filename[0:-3], filepath), attribute.replace(' ', ''))
			genericViewForms.append(GetGenericViewForm(newClass(), attribute))
	return genericViewForms


def GetGenericViewForm(cls, entity):
	form = {'sView Form Name':entity, 'lstForm Field':list(), 'sEntity Name':entity, 'lstAction':list(), 'sTab Label':entity, 'sColumns in Layout':'One Column'}
	index = 0
	for i in range(0, len(cls.Attributes)):
		formField = ewp.GetFormField(index, cls.Attributes[i], cls.Options[i], entity)
		if formField != None:
			form['lstForm Field'].append(formField)
			index = index + 1
	form['lstAction'].append(GiveName({'sLabel':'&Delete', 'sAction':'Delete', 'sTarget':'VW:' + entity, 'sMnemonic':'D'}))
	form['lstAction'].append(GiveName({'sLabel':'&Edit', 'sAction':'Edit', 'sTarget':'EDW:' + entity, 'sMnemonic':'E'}))
	form['lstAction'].append(GiveName({'sLabel':'Send E&Mail', 'sAction':'Send EMail', 'sTarget':'ENTITY_WORKSPACE : ' + entity, 'sMnemonic':'M'}))
	return GiveName(form)


def GetViewSimpleLists(obj, entity, filename, filepath):
	viewSimpleLists = list()
	for i in range(0, len(obj.Attributes)):
		if obj.Attributes[i].startswith('arr'):
			viewSimpleLists.append(GetViewSimpleList(obj.Attributes[i], obj.Options[i], entity))
	return viewSimpleLists

def GetViewSimpleList(attribute, options, entity):
	simpleList = {'sView Simple List Name':attribute, 'sTab Label':attribute[3:], 'sAttribute Name':entity + '.' + attribute, 'lstAction':list(), 'dctChoice':options}
	simpleList['lstAction'].append(GiveName({'sLabel':'&Add', 'sAction':'Add Item', 'sTarget':'-:', 'sMnemonic':'A'}))
	simpleList['lstAction'].append(GiveName({'sLabel':'&Edit', 'sAction':'Edit Item', 'sTarget':'-:', 'sMnemonic':'E'}))
	simpleList['lstAction'].append(GiveName({'sLabel':'&Delete', 'sAction':'Delete Item', 'sTarget':'-:', 'sMnemonic':'D'}))
	return GiveName(simpleList)

def GetViewObjectLists(obj, entity, filename, filepath):
	objectLists = list()
	for i in range(0, len(obj.Attributes)):
		if obj.Attributes[i].startswith('lst'):
			objectLists.append(GetViewObjectList(obj.Attributes[i], filename, filepath))
	return objectLists

def GetViewObjectList(entity, filename, filepath):
	objectList = {'sView Object List Name':entity, 'sTab Label':entity[3:], 'lstColumn':list(), 'lstAction':list()}
	obj = getattr(imp.load_source(filename[0:-3], filepath), entity[3:].replace(' ', ''))()
	for i in range(0, len(obj.Attributes)):
		attribute = obj.Attributes[i]
		if attribute[0] == 's' or attribute[0] == 'i' or attribute[0] == 'f' or attribute[0] == 'b':
			column = {'sColumn Name':entity[3:] + '.' + attribute, 'sColumn Label':attribute[1:]}
			objectList['lstColumn'].append(GiveName(column))
	objectList['lstAction'].append(GiveName({'sLabel':'&Select', 'sAction':'Select Item', 'sTarget':'SEARCH_WORKSPACE : ' + attribute, 'sMnemonic':'S'}))
	objectList['lstAction'].append(GiveName({'sLabel':'&New', 'sAction':'New Item', 'sTarget':'ENTITY_WORKSPACE : ' + attribute, 'sMnemonic':'A'}))
	objectList['lstAction'].append(GiveName({'sLabel':'&Edit', 'sAction':'Edit Item', 'sTarget':'-:', 'sMnemonic':'E'}))
	objectList['lstAction'].append(GiveName({'sLabel':'&Delete', 'sAction':'Delete Item', 'sTarget':'-:', 'sMnemonic':'D'}))
	objectList['lstAction'].append(GiveName({'sLabel':'Send E&Mail', 'sAction':'Send EMail', 'sTarget':'MAIL_WORKSPACE : ', 'sMnemonic':'M'}))
	return GiveName(objectList)

#################################################################################################

#				     Menu Builder Functions					#

#################################################################################################

def GetNavigation(entityList, filename, filepath):
	menus = list()
	menus.append(GiveName({'sMenu Name':'&xCelestia', 'lstMenu Option':list()}))
	menus.append(GiveName({'sMenu Name':'&New', 'lstMenu Option':list()}))
	menus.append(GiveName({'sMenu Name':'&Search', 'lstMenu Option':list()}))
	menus.append(GiveName({'sMenu Name':'&Reports', 'lstMenu Option':list()}))
	menus.append(GiveName({'sMenu Name':'&Graphs', 'lstMenu Option':list()}))
	menus.append(GiveName({'sMenu Name':'&Options', 'lstMenu Option':list()}))
	menus.append(GiveName({'sMenu Name':'&Help', 'lstMenu Option':list()}))

	menus[0]['lstMenu Option'].append(GiveName({'sOption Label':'&Preferences', 'sMnemonic':'P', 'sMenuoption Action':'xCelestia Preferences', 'sTarget':'PREF:'}))
	menus[0]['lstMenu Option'].append(GiveName({'sOption Label':'&Dash Board', 'sMnemonic':'D', 'sMenuoption Action':'Show Dashboard', 'sTarget':'DASH_BOARD'}))
	menus[0]['lstMenu Option'].append(GiveName({'sOption Label':'-', 'sMnemonic':'', 'sMenuoption Action':'None', 'sTarget':'-:'}))
	menus[0]['lstMenu Option'].append(GiveName({'sOption Label':'&Log off', 'sMnemonic':'L', 'sMenuoption Action':'Log Off', 'sTarget':'LOG_OFF:'}))
	menus[0]['lstMenu Option'].append(GiveName({'sOption Label':'E&xit/Quit', 'sMnemonic':'x', 'sMenuoption Action':'Exit', 'sTarget':'EXIT:'}))
	for entity in entityList:
		cls = getattr(imp.load_source(filename[0:-3], filepath), entity)
		menus[1]['lstMenu Option'].append(GiveName({'sOption Label':entity, 'sMnemonic':'', 'sMenuoption Action':'Open New Form', 'sTarget':'ENTITY_WORKSPACE : ' + entity}))
		menus[2]['lstMenu Option'].append(GiveName({'sOption Label':entity, 'sMnemonic':'', 'sMenuoption Action':'Open Search Form', 'sTarget':'SEARCH_WORKSPACE : ' + entity}))
		menus[3]['lstMenu Option'].append(GiveName({'sOption Label':entity, 'sMnemonic':'', 'sMenuoption Action':'Open Report', 'sTarget':'REPORT : ' + entity}))
		menus[4]['lstMenu Option'].append(GiveName({'sOption Label':entity, 'sMnemonic':'', 'sMenuoption Action':'Open Graph', 'sTarget':'GRAPH : ' + entity}))
	menus[5]['lstMenu Option'].append(GiveName({'sOption Label':'Select Theme', 'sMnemonic':'', 'sMenuoption Action':'Select Theme', 'sTarget':'THM:'}))
	menus[5]['lstMenu Option'].append(GiveName({'sOption Label':'Font', 'sMnemonic':'', 'sMenuoption Action':'Select Font', 'sTarget':'FONT:'}))
	menus[6]['lstMenu Option'].append(GiveName({'sOption Label':'&About xCelestia', 'sMnemonic':'A', 'sMenuoption Action':'About Software', 'sTarget':'ABT:'}))
	menus[6]['lstMenu Option'].append(GiveName({'sOption Label':'&Help Contents', 'sMnemonic':'H', 'sMenuoption Action':'View Help', 'sTarget':'HLP:'}))
	return menus

#################################################################################################

#				     Miscellaneous Functions					#

#################################################################################################

def GiveName(ref):
	for key in ref.keys():
		if ClassMapper != None and ClassMapper.Map.has_key(key):
			prefix = ClassMapper.Map[key]
			suffix = ref[key]

			ref[key] = prefix + suffix
	return ref
	pass


def String(ref):
	#print ref
	for key in ref.keys():
		if ClassMapper != None and ClassMapper.Map.has_key(key):
			return ref[key]
	return str(ref)
	pass

