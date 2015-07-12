class Project:

	def __init__(self):
		self.Attributes = ('sProject Name', 'sSource File', 'sOutput Directory', 'Database Properties', 'lstProfile', 'Rendering Properties', 'lstDatabase Table')
		self.Options = (None, None, None, None, None, None, None, None)

class DatabaseProperties:

	def __init__(self):
		self.Attributes = ('sServer Type', 'sServer Name', 'sUsername', 'sPassword', 'sDatabase Name', 'bStatements end in Semicolon', 'bCase Sensitive SQL', 'bSupports Foreign Key')
		self.Options = (('MySQL Server', 'MS SQL Server', 'Oracle'), None, None, None, None, None, None, None)

class RenderingProperties:

	def __init__(self):
		self.Attributes = list()
		self.Attributes.append('sForm Rendering')
		self.Options = (('Render Single Page forms', 'Render Forms with Tabs'), None, None)

class Profile:

	def __init__(self):
		self.Attributes = ('sProfile Name', 'sOutput Directory', 'lstMenu', 'lstEntity Workspace', 'lstGraph', 'lstSearch Workspace', 'lstView Workspace', 'lstReport', 'lstEditor Workspace', 'lstDatabase Table')
		self.Options = (None, None, None, None, None, None, None, None, None)

class EditorWorkspace:

	def __init__(self):
		self.Attributes = ('sEditor Workspace Name', 'sEntity Name', 'lstForm', 'lstObject List', 'lstSimple List')
		self.Options = (None, None, None, None, None, None, None)

class EntityWorkspace:

	def __init__(self):
		self.Attributes = ('sEntity Workspace Name', 'sEntity Name', 'lstForm', 'lstObject List', 'lstSimple List', 'lstEntity Workspace Panel')
		self.Options = (None, None, None, None, None, None, None)

class EntityWorkspacePanel:

	def __init__(self):
		self.Attributes = ('sEntity Workspace Name', 'sEntity Name', 'lstForm', 'lstObject List', 'lstSimple List', 'lstEntity Workspace Panel')
		self.Options = (None, None, None, None, None, None, None)

class Form:

	def __init__(self):
		self.Attributes = ('sForm Name', 'lstForm Field', 'sEntity Name', 'lstAction', 'sTab Label', 'sColumns in Layout', 'sPre Submission Validator(s)', 'sPost Submission Trigger Name(s)')
		self.Options = (None, None, None, None, None, ('One Column', 'Two Columns', 'Custom Layout'), None, None, None, None)

class FormField:

	def __init__(self):
		self.Attributes = ('sForm Field Name', 'sAttribute Name', 'sField Label', 'iType', 'iSize', 'dctOption', 'sValidation Message', 'sDefault Value', 'sPre Focus Validator', 'sPost Focus Validator', 'sDefault Value Generator', 'Form Field Layout')
		self.Options = (None, None, None, ('Text Control', 'Multiline Text Control', 'Combo Box', 'List Box', 'Check Box', 'Radio Button', 'File Picker', 'Email Control'), None, None, None, None, None, None, None, None, None, None, None, None, None, None, None)

class FormFieldLayout:

	def __init__(self):
		self.Attributes = ('iGrid Row', 'iGrid Column', 'iGrid Width', 'iGrid Height', 'bExpand Horizontally', 'bExpand Vertically')
		self.Options = (None, None, None, None, None, None, None, None, None, None, None, None)

class ObjectList:

	def __init__(self):
		self.Attributes = ('sObject List Name', 'sTab Label', 'lstColumn', 'lstAction', 'Entity Workspace', 'Editor Workspace', 'Search Workspace')
		self.Options = (None, None, None, None, None, None, None)

class Column:

	def __init__(self):
		self.Attributes = ('sColumn Name', 'sColumn Label')
		self.Options = (None, None, None, None, None, None, None)

class Action:

	def __init__(self):
		self.Attributes = ('sLabel', 'sAction', 'sTarget', 'sMnemonic')
		self.Options = (None, ('None', 'Log Off', 'Show Dashboard', 'Exit', 'Open New Form', 'Open Search Form', 'Open Graph', 'Open Report', 'Select Theme', 'Select Font', 'Save Form Data', 'Clear Form', 'Cancel Action', 'Delete', 'Edit', 'Send EMail', 'Close Window', 'Search', 'New Form', 'View', 'About Software', 'View Help', 'Add Item', 'Edit Item', 'Delete Item'), None, None, None, None, None)

class SimpleList:

	def __init__(self):
		self.Attributes = ('sSimple List Name', 'sTab Label', 'sAttribute Name', 'lstAction', 'dctChoice')
		self.Options = (None, None, None, None, None, None, None)

class SearchWorkspace:

	def __init__(self):
		self.Attributes = ('sSearch Workspace Name', 'sEntity Name', 'lstSearch Criteria', 'lstColumn', 'lstAction', 'Editor Workspace')
		self.Options = (None, None, None, None, None, None, None, None)

class SearchCriteria:

	def __init__(self):
		self.Attributes = ('sSearch Criteria Name', 'sLabel', 'sSearch Type')
		self.Options = (None, None, ('Exact Search', 'Range Search', 'Similar Search'), None, None, None)

class Graph:

	def __init__(self):
		self.Attributes = ('sGraph Name', 'sEntity Name', 'sSQL Statement', 'sX-Axis Column Name', 'sY-Axis Column Name', 'sType of Graph')
		self.Options = (None, None, None, None, None, None, None)

class ViewWorkspace:

	def __init__(self):
		self.Attributes = ('sView Workspace Name', 'sEntity Name', 'lstView Form', 'lstView Object List', 'lstView Simple List')
		self.Options = (None, None, None, None, None, None, None)

class ViewForm:

	def __init__(self):
		self.Attributes = ('sView Form Name', 'lstForm Field', 'sEntity Name', 'lstAction', 'sTab Label', 'sColumns in Layout')
		self.Options = (None, None, None, None, None, ('One Column', 'Two Columns', 'Custom Layout'), None)

class ViewObjectList:

	def __init__(self):
		self.Attributes = ('sView Object List Name', 'sTab Label', 'lstColumn', 'lstAction')
		self.Options = (None, None, None, None, None, None, None)

class ViewSimpleList:

	def __init__(self):
		self.Attributes = ('sView Simple List Name', 'sTab Label', 'sAttribute Name', 'lstAction')
		self.Options = (None, None, None, None, None, None, None)

class Report:

	def __init__(self):
		self.Attributes = ('sReport Name', 'sSQL Statement', 'iRecords Per Page', 'lstAction')	# lstAction is what all can be done with the records like delete, edit, send email, view
		self.Options = (None, None, None, None)
class Menu:

	def __init__(self):
		self.Attributes = ('sMenu Name', 'lstMenu Option')
		self.Options = (None, None, None, None, None, None, None)

class MenuOption:

	def __init__(self):
		self.Attributes = ('sOption Label', 'sMnemonic', 'sMenuoption Action', 'sTarget')
		self.Options = (None, None, None, None, None, None, None)

class DictionaryEntry:

	def __init__(self):
		self.Attributes = ('sName', 'sValue')
		self.Options = (None, None)

class DatabaseTable:

	def __init__(self):
		self.Attributes = ('sTable Name', 'lstDatabase Column', 'sEntity Name')
		self.Options = (None, None)

class DatabaseColumn:

	def __init__(self):
		self.Attributes = ('sField Name', 'sType', 'iSize', 'bPrimary Key', 'bAuto Incremented', 'sAttribute Name')
		self.Options = (None, ('int', 'bigint', 'varchar', 'float', 'double', 'datetime', 'mediumblob', 'longblob'), None, None, None, None, None)

class ClassMapper:

	def __init__(self):
		self.Map = {'sProfile Name':'', 'sEntity Workspace Name':'ENTITY_WORKSPACE : ', 'sForm Name':'FORM : ', 'sObject List Name':'OBJECT_LIST : ', 'sSimple List Name':'SIMPLE_LIST : ', 'sSearch Workspace Name':'SEARCH_WORKSPACE : ', 'sForm Field Name':'FORM_FIELD : ', 'sSearch Criteria Name':'SEARCH_CRITERIA : ', 'sColumn Name':'REPORT_COLUMN : ', 'sView Workspace Name':'VIEW_WORKSPACE : ', 'sView Form Name':'VIEW_FORM : ', 'sGraph Name':'GRAPH : ', 'sReport Name':'REPORT : ', 'sAction':'ACTION : ', 'sMenu Name':'MENU : ', 'sOption Label':'MENU_OPTION : ', 'sObject List Name':'OBJECT_LIST : ', 'sSimple List Name':'SIMPLE_LIST : ', 'sView Simple List Name':'VIEW_SIMPLE_LIST : ', 'sView Object List Name':'VIEW_OBJECT_LIST : ', 'sEditor Workspace Name':'EDITOR_WORKSPACE : '}


