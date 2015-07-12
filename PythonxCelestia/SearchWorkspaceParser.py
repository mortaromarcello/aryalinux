import EntityWorkspaceParser as ewp
import EditorWorkspaceParser as edwp
import functions as fun

'''
	Search Workspaces are no alien
	They also follow the same nomenclature.
	Search Criteria have the same name as the form field, so that they search form right database column
'''

def GetAllSearchWorkspaces(entityList, filename, filepath):
	searchWorkspaces = list()
	for entity in entityList:
		searchWorkspaces.append(fun.GiveName(GetSearchWorkspace(entity, filename, filepath)))
	return searchWorkspaces

def GetSearchWorkspace(entity, filename, filepath):
	ref = ewp.GetObject(entity, filename, filepath)
	searchWorkspace = {'sSearch Workspace Name':entity, 'sEntity Name':entity, 'lstSearch Criteria':list(), 'lstColumn':list(), 'lstAction':list(), 'Editor Workspace':None, 'Entity Workspace':None}
	for attribute in ref.Attributes:
		if attribute.startswith('s') or attribute.startswith('i') or attribute.startswith('b') or attribute.startswith('f') or attribute.startswith('d') or attribute.startswith('e'):
			if not attribute.startswith('file'):
				searchCriteria = {'sSearch Criteria Name':entity + '_' + attribute.replace(' ', '_').replace('\'', '').replace('/', '').replace('?', ''), 'sLabel':attribute, 'sSearch Type':'Exact Search'}
				searchWorkspace['lstSearch Criteria'].append(fun.GiveName(searchCriteria))
				column = {'sColumn Name':entity + '_' + attribute.replace(' ', '_').replace('\'', '').replace('/', '').replace('?', ''), 'sColumn Label':None}
				if attribute.startswith('s') or attribute.startswith('i') or attribute.startswith('b') or attribute.startswith('f') or attribute.startswith('d') or attribute.startswith('e'):
					column['sColumn Label'] = attribute[1:]
				elif attribute.startswith('lst') or attribute.startswith('arr'):
					column['sColumn Label'] = attribute[3:]
				else:
					column['sColumn Label'] = attribute
				searchWorkspace['lstColumn'].append(fun.GiveName(column))
	searchWorkspace['lstAction'].append(fun.GiveName({'sLabel':'&Edit', 'sAction':'Edit Item', 'sTarget':'EDITOR_WORKSPACE : ' + attribute, 'sMnemonic':'E'}))
	searchWorkspace['lstAction'].append(fun.GiveName({'sLabel':'&Delete', 'sAction':'Delete Item', 'sTarget':'-:', 'sMnemonic':'D'}))
	searchWorkspace['lstAction'].append(fun.GiveName({'sLabel':'Send E&Mail', 'sAction':'Send EMail', 'sTarget':'MAIL_WORKSPACE : ', 'sMnemonic':'M'}))
	searchWorkspace['Editor Workspace'] = ewp.GetEntityWorkspace(entity, filename, filepath, True)
	return searchWorkspace

