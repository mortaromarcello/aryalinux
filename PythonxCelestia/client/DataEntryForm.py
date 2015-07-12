import wx
import ButtonPanel as bp
import Client as client
import Form as frm
import EventHandler as eh
import DatabaseFunctions as db
import GenericSearch as gs

class DataEntryForm(wx.Panel):

	def __init__(self, parent, selectEventHandler=None):
		wx.Panel.__init__(self, parent, -1)
		self.SelectEventHandler = selectEventHandler
		self.SetSizer(wx.GridBagSizer())
		self.GetSizer().AddGrowableRow(2)
		self.GetSizer().AddGrowableCol(0)
		self.ButtonPanel = None
		self.Form = None
		self.Triggers = list()

	def Reset(self):
		self.Form.Reset()

	def SetValue(self, data):
		self.Form.SetValue(data)
		pass

	def GetValue(self):
		return self.Form.GetValue()

	def Initialize(self, form, globalVars):
		self.FormData = form
		self.GlobalVars = globalVars
		self.InitializeButtonPanel(globalVars)
		self.GetSizer().Add(wx.StaticLine(self, -1), (1, 0), (1, 1), wx.EXPAND, 10)
		self.Form = frm.Form(self, self.FormData)
		self.GetSizer().Add(self.Form, (2, 0), (1, 1), wx.ALIGN_CENTER | wx.EXPAND)
		self.InitializeTriggers()
		pass

	def InitializeButtonPanel(self, globalVars):
		buttons = list()
		for action in self.FormData['lstAction']:
			if action['sLabel'] == '&Select':
				buttons.append((action['sLabel'], self.SelectEventHandler))
			else:
				buttons.append((action['sLabel'], self.GlobalVars['EventHandler'].DispatchAction))
		self.ButtonPanel = bp.ButtonPanel(self, buttons, globalVars)
		for action in self.FormData['lstAction']:
			globalVars['Actions'][globalVars['CurrentActionID']] = action['sAction'] + '/' + action['sTarget']
			globalVars['CurrentActionID'] = globalVars['CurrentActionID'] + 1
		self.GetSizer().Add(self.ButtonPanel, (0, 0), (1, 1), wx.ALIGN_RIGHT | wx.ALL, 5)
		pass

	def InitializeFormFields(self):
		self.Form = frm.Form(self, self.FormData)
		self.GetSizer().Add(self.Form, (2, 0), (1, 1), wx.ALIGN_CENTER | wx.EXPAND)
		pass

	def InitializeTriggers(self):
		pass

	def AddPostTrigger(self, ref):
		pass

	def AddPreTrigger(self, ref):
		pass

	def GetForm(self):
		return self.Form

	def OnSelect(self, event):
		pass

	def SetSelectEventHandler(self, select):
		self.SelectEventHandler = select

