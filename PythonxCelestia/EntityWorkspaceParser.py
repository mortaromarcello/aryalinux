import imp
import time
import functions as fun
import EditorWorkspaceParser as edwp
import SearchWorkspaceParser as swp

'''
	This module's functions are for parsing the source file to produce the Entity Workspace dictionary
	The purpose here is to use the same nomenclature as used to generate the database structure so that not much effort happens while fetching or setting data.
'''

def GetAllEntityWorkspaces(entityList, filename, filepath):
	entityWorkspaces = list()
	for entity in entityList:
		entityWorkspace = GetEntityWorkspace(entity, filename, filepath, True)
		entityWorkspaces.append(fun.GiveName(entityWorkspace))
	return entityWorkspaces
	pass

'''
	Since an Entity Workspace leads to addition of data into just a single table, its safe to link it with some table. The link here is the entity name.
	So when an entity workspace returns data, it tags its name with the main form so that data can be easily extracted and fed to the data source.
'''

def GetEntityWorkspace(entity, filename, filepath, parseLast):
        ref = GetObject(entity, filename, filepath)
	entityWorkspace = {'sEntity Workspace Name':entity, 'sEntity Name':entity, 'lstForm':list(), 'lstObject List':list(), 'lstSimple List':None}
	entityWorkspace['lstForm'].append(GetEntityPropertiesForm(ref, entity))
	if GetSimpleLists(ref, entity, filename, filepath) != None:
		entityWorkspace['lstSimple List'] = GetSimpleLists(ref, entity, filename, filepath)
	if GetObjectLists(ref, entity, filename, filepath) != None:
		entityWorkspace['lstObject List'] = GetObjectLists(ref, entity, filename, filepath)
		for objectList in entityWorkspace['lstObject List']:
			del objectList['lstAction'][0]
			del objectList['lstAction'][1]
			del objectList['lstAction'][2]
	if parseLast:
		if GetEntityWorkspaces(ref, entity, filename, filepath) != None:
			entityWorkspace['lstEntity Workspace Panel'] = GetEntityWorkspaces(ref, entity, filename, filepath)
        return entityWorkspace

def GetEntityWorkspaces(obj, entity, filename, filepath):
	entityWorkspaces = list()
	for i in range(0, len(obj.Attributes)):
		if not(obj.Attributes[i].startswith('arr') or obj.Attributes[i].startswith('lst') or obj.Attributes[i].startswith('file') or obj.Attributes[i].startswith('s') or obj.Attributes[i].startswith('i') or obj.Attributes[i].startswith('f') or obj.Attributes[i].startswith('b') or obj.Attributes[i].startswith('e') or obj.Attributes[i].startswith('file') or obj.Attributes[i].startswith('d')):
			if obj.Attributes[i].replace(' ', '') != entity:
				entityWorkspaces.append(fun.GiveName(GetEntityWorkspace(obj.Attributes[i].replace(' ', ''), filename, filepath, False)))
	return entityWorkspaces

def GetSimpleLists(obj, entity, filename, filepath):
	simpleLists = list()
	for i in range(0, len(obj.Attributes)):
		if obj.Attributes[i].startswith('arr'):
			simpleLists.append(GetSimpleList(obj.Attributes[i], obj.Options[i], entity))
	return simpleLists
'''
	The name of a simple list would be the same as the table where its data would be stored.
	When the Entity workspace would return its data, its name would simply be preceded by 'SIMPLE_LIST : ' which can be eliminated.
	The Attribute Name holds the column name into which the list's data would go
'''
def GetSimpleList(attribute, options, entity):
	simpleList = {'sSimple List Name':entity + '_' + attribute.replace(' ', '_').replace('\'', '').replace('/', '').replace('?', ''), 'sTab Label':attribute[3:], 'sAttribute Name':entity + '_' + attribute[3:].replace(' ', '_').replace('\'', '').replace('/', '').replace('?', ''), 'lstAction':list(), 'dctChoice':options}
	simpleList['lstAction'].append(fun.GiveName({'sLabel':'&Add', 'sAction':'Add Item', 'sTarget':'-:', 'sMnemonic':'A'}))
	simpleList['lstAction'].append(fun.GiveName({'sLabel':'&Edit', 'sAction':'Edit Item', 'sTarget':'-:', 'sMnemonic':'E'}))
	simpleList['lstAction'].append(fun.GiveName({'sLabel':'&Delete', 'sAction':'Delete Item', 'sTarget':'-:', 'sMnemonic':'D'}))
	return fun.GiveName(simpleList)

def GetObjectLists(obj, entity, filename, filepath):
	objectLists = list()
	for i in range(0, len(obj.Attributes)):
		if obj.Attributes[i].startswith('lst'):
			objectLists.append(GetObjectList(obj.Attributes[i], filename, filepath, entity))
	return objectLists

'''
	Object Lists would have the same name as the table where their data would go.
	When its data would be retreived through an entity workspace the name would simple be preceded by an 'OBJECT_LIST' that can be eliminated
	This Object list would also show an Entity Workspace when the New button would be clicked.
	The name of this Entity Workspace would also follow the same principles as the containing Entity Workspace.
	There are columns as well in the Object list which would get data from the entity workspace. It would suit our purpose to have them with same names
	as the fields of the form they come from.
'''

def GetObjectList(entity, filename, filepath, parentEntity):
	objectList = {'sObject List Name':parentEntity + '_' + entity.replace(' ', '_').replace('\'', '').replace('/', '').replace('?', ''), 'sTab Label':entity[3:], 'lstColumn':list(), 'lstAction':list(), 'Entity Workspace':None, 'Editor Workspace':None}
	obj = GetObject(entity[3:].replace(' ', ''), filename, filepath)

	for i in range(0, len(obj.Attributes)):
		attribute = obj.Attributes[i]
		if attribute[0] == 's' or attribute[0] == 'i' or attribute[0] == 'f' or attribute[0] == 'b' or attribute[0] == 'd' or attribute[0] == 'e':
			column = {'sColumn Name':entity[3:].replace(' ', '') + '_' + attribute.replace(' ', '_').replace('\'', '').replace('/', '').replace('?', ''), 'sColumn Label':attribute[1:]}
			objectList['lstColumn'].append(fun.GiveName(column))

	objectList['lstAction'].append(fun.GiveName({'sLabel':'&Select', 'sAction':'Select Item', 'sTarget':'SEARCH_WORKSPACE : ', 'sMnemonic':'S'}))
	objectList['lstAction'].append(fun.GiveName({'sLabel':'&New', 'sAction':'New Item', 'sTarget':'ENTITY_WORKSPACE : ', 'sMnemonic':'A'}))
	objectList['lstAction'].append(fun.GiveName({'sLabel':'&Edit', 'sAction':'Edit Item', 'sTarget':'EDITOR_WORKSPACE : ', 'sMnemonic':'E'}))
	objectList['lstAction'].append(fun.GiveName({'sLabel':'&Delete', 'sAction':'Delete Item', 'sTarget':'-:', 'sMnemonic':'D'}))
	objectList['lstAction'].append(fun.GiveName({'sLabel':'Send E&Mail', 'sAction':'Send EMail', 'sTarget':'MAIL_WORKSPACE : ', 'sMnemonic':'M'}))
	objectList['Entity Workspace'] = fun.GiveName(GetEntityWorkspace(entity[3:].replace(' ', ''), filename, filepath, False))
	objectList['Editor Workspace'] = fun.GiveName(edwp.GetEditorWorkspace(entity[3:].replace(' ', ''), filename, filepath))
	objectList['Search Workspace'] = fun.GiveName(swp.GetSearchWorkspace(entity[3:].replace(' ', ''), filename, filepath))
	return fun.GiveName(objectList)
'''
	The Entity Property form is the first page of an entity workspace.
	It has the same name as the entity workspace itself except of course that it has "FORM : " prefixed
'''

def GetEntityPropertiesForm(cls, entity):
	form = {'sForm Name':entity, 'lstForm Field':list(), 'sEntity Name':entity, 'lstAction':list(), 'sTab Label':entity, 'sColumns in Layout':'One Column', 'sPre Submission Validator(s)':'', 'sPost Submission Trigger Name(s)':''}
	index = 0
	for i in range(0, len(cls.Attributes)):
		formField = GetFormField(index, cls.Attributes[i], cls.Options[i], entity)
		if formField != None:
			form['lstForm Field'].append(formField)
			index = index + 1
	form['lstAction'].append(fun.GiveName({'sLabel':'&Save', 'sAction':'Save Form Data', 'sTarget':'ENTITY_WORKSPACE : ' + entity, 'sMnemonic':'S'}))
	form['lstAction'].append(fun.GiveName({'sLabel':'&Reset', 'sAction':'Clear Form', 'sTarget':'ENTITY_WORKSPACE : ' + entity, 'sMnemonic':'R'}))
	form['lstAction'].append(fun.GiveName({'sLabel':'&Cancel', 'sAction':'Cancel Action', 'sTarget':'ENTITY_WORKSPACE : ' + entity, 'sMnemonic':'C'}))
	return fun.GiveName(form)
	pass

'''
	The form field has the same name as the attribute name of a database column
	This name also matches the name of the column in Object List
	In this case also attribute name is derogatory. Would eventually remove this as well.
'''

def GetFormField(index, attribute, options, entity):
	if attribute.startswith('s') or attribute.startswith('i') or attribute.startswith('b') or attribute.startswith('f') or attribute.startswith('d')or attribute.startswith('e') or attribute.startswith('file') and not attribute.startswith('arr') and not attribute.startswith('lst'):
		formField = {'sForm Field Name':entity + '_' + attribute.replace(' ', '_').replace('\'', '').replace('/', '').replace('?', ''), 'sAttribute Name':entity.replace(' ', '') + '.' + attribute, 'sField Label':attribute, 'iType':None, 'iSize':None, 'dctOption':None, 'sValidation Message':'', 'sDefault Value':'', 'sPre Focus Validator':'', 'sPost Focus Validator':'', 'sDefault Value Generator':'', 'Form Field Layout':None}
		if attribute.startswith('file'):
			formField['sField Name'] = attribute[4:]
		else:
			formField['sField Name'] = attribute[1:]

		if attribute.startswith('file'):
			formField['iType'] = 'File Picker'
		elif attribute.startswith('i'):
			formField['iSize'] = 5
			formField['iType'] = 'Text Control'
		elif attribute.startswith('b'):
			formField['iType'] = 'Check Box'
		elif attribute.startswith('s'):
			formField['iSize'] = 25
			formField['iType'] = 'Text Control'
		elif attribute.startswith('f'):
			formField['iSize'] = 10
			formField['iType'] = 'Text Control'
		elif attribute.startswith('d'):
			formField['iType'] = 'Date Picker'
			formField['iSize'] = 15
		elif attribute.startswith('e'):
			formField['iType'] = 'Email Control'
			formField['iSize'] = 25
			formField['sPost Focus Validator'] = 'EMailValidator'
		if options != None:
			formField['dctOption'] = options
			formField['iType'] = 'Combo Box'
		formField['Form Field Layout'] = GetFormFieldLayout(index, attribute)
		return fun.GiveName(formField)
	else:
		return None
	pass

def GetFormFieldLayout(index, attribute):
	formFieldLayout = {'iGrid Row':index, 'iGrid Column':1, 'iGrid Width':1, 'iGrid Height':1, 'bExpand Horizontally':False, 'bExpand Vertically':False}
	return fun.GiveName(formFieldLayout)

def GetGenericForms(cls, entity, filename, filepath):
	genericForms = list()
	for attribute in cls.Attributes:
		if not(attribute.startswith('s') or attribute.startswith('i') or attribute.startswith('e') or attribute.startswith('b') or attribute.startswith('f') or attribute.startswith('d') or attribute.startswith('lst') or attribute.startswith('arr')):
			ref = GetObject(entity, filename, filepath)
			genericForms.append(GetGenericForm(ref, attribute, entity))
	return genericForms
'''
	Generic Forms dont show up in Entity workspaces but they would be present in Editor Workspaces.
	In case of editor workspaces we need to have the same name for them as the name of the table where their data would go
'''
def GetGenericForm(ref, entity, parentEntity):
	form = {'sForm Name':parentEntity + '_' + entity.replace(' ', '_').replace('\'', '').replace('/', '').replace('?', ''), 'lstForm Field':list(), 'sEntity Name':entity, 'lstAction':list(), 'sTab Label':entity, 'sColumns in Layout':'One Column', 'sPre Submission Validator(s)':'', 'sPost Submission Trigger Name(s)':''}
	index = 0
	for i in range(0, len(ref.Attributes)):
		formField = GetFormField(index, ref.Attributes[i], ref.Options[i], entity)
		if formField != None:
			form['lstForm Field'].append(formField)
			index = index + 1
	form['lstAction'].append(fun.GiveName({'sLabel':'&Select', 'sAction':'Search', 'sTarget':'SEARCH_WORKSPACE : ' + entity, 'sMnemonic':'S'}))
	form['lstAction'].append(fun.GiveName({'sLabel':'&New', 'sAction':'New Form', 'sTarget':'ENTITY_WORKSPACE : ' + entity, 'sMnemonic':'R'}))
	return fun.GiveName(form)

def GetObject(entity, filename, filepath):
	ref = getattr(imp.load_source(filename[0:-3], filepath), entity)()
	return ref

