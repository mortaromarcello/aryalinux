import imp
import EntityWorkspaceParser as ewp
import functions as fun

'''
	This is not very different from Entity Workspace. In fact this is the reason why there are few functions here
	Most functions are borrowed from the EntityWorkspaceParser module
'''

def GetAllEditorWorkspaces(entityList, filename, filepath):
	editorWorkspaces = list()
	for entity in entityList:
		editorWorkspace = GetEditorWorkspace(entity, filename, filepath)
		editorWorkspaces.append(fun.GiveName(editorWorkspace))
	return editorWorkspaces
	pass

def GetEditorWorkspace(entity, filename, filepath):
        ref = ewp.GetObject(entity, filename, filepath)
	editorWorkspace = {'sEditor Workspace Name':entity, 'sEntity Name':entity, 'lstForm':list(), 'lstObject List':list(), 'lstSimple List':None}
	editorWorkspace['lstForm'].append(ewp.GetEntityPropertiesForm(ref, entity))

	genericForms = ewp.GetGenericForms(ref, entity, filename, filepath)
	for genericForm in genericForms:
		editorWorkspace['lstForm'].append(genericForm)

	if ewp.GetSimpleLists(ref, entity, filename, filepath) != None:
		editorWorkspace['lstSimple List'] = ewp.GetSimpleLists(ref, entity, filename, filepath)
	if ewp.GetObjectLists(ref, entity, filename, filepath) != None:
		editorWorkspace['lstObject List'] = ewp.GetObjectLists(ref, entity, filename, filepath)
        return editorWorkspace

