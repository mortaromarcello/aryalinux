import wx
import Client as client
import EventHandler as eh

class ButtonPanel(wx.Panel):

	def __init__(self, parent, buttons, globalVars):
		wx.Panel.__init__(self, parent)
		self.SetSizer(wx.GridSizer(1, len(buttons), 5, 5))
		buttonID = globalVars['CurrentActionID']
		for labelAndEventHandler in buttons:
			button = wx.Button(self, buttonID, labelAndEventHandler[0])
			if buttonID == wx.ID_OK:
				button.SetDefault()
			self.GetSizer().Add(button, wx.ALL | wx.EXPAND, 5)
			button.Bind(wx.EVT_BUTTON, labelAndEventHandler[1], button)
			buttonID = buttonID + 1

