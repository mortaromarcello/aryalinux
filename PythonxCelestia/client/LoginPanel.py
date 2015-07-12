import wx

class LoginPanel(wx.Panel):

	def __init__(self, parent, globalVars):
		wx.Panel.__init__(self, parent, -1)
		self.Container = wx.Panel(self, -1)
		self.Container.SetSizer(wx.GridBagSizer())
		self.SetSizer(wx.GridBagSizer())
		self.GetSizer().AddGrowableRow(0)
		self.GetSizer().AddGrowableCol(0)
		self.GetSizer().Add(self.Container, (0, 0), (1, 1), wx.ALIGN_CENTER_VERTICAL | wx.ALIGN_CENTER)
		self.Initialize(globalVars)

	def Initialize(self, globalVars):
		self.Username = wx.TextCtrl(self.Container, -1)
		self.Password = wx.TextCtrl(self.Container, -1, style=wx.TE_PASSWORD)
		self.LoginButton = wx.Button(self.Container, globalVars['CurrentActionID'], 'Login')
		globalVars['Actions'][globalVars['CurrentActionID']] = 'Log In/'
		globalVars['CurrentActionID'] = globalVars['CurrentActionID'] + 1
		self.Container.GetSizer().Add(wx.StaticText(self.Container, -1, 'Please enter your username and password for authentication'), (0, 5), (1, 31), wx.EXPAND | wx.ALIGN_CENTER)
		self.Container.GetSizer().Add(wx.StaticLine(self.Container), (2, 0), (1, 31), wx.EXPAND)
		self.Container.GetSizer().Add(wx.StaticText(self.Container, -1, 'Username'), (4, 6), (1, 1), wx.ALIGN_RIGHT | wx.ALIGN_CENTER_VERTICAL | wx.ALL, 3)
		self.Container.GetSizer().Add(wx.StaticText(self.Container, -1, 'Password'), (5, 6), (1, 1), wx.ALIGN_RIGHT | wx.ALIGN_CENTER_VERTICAL | wx.ALL, 3)
		self.Container.GetSizer().Add(self.Username, (4, 7), (1, 20), wx.ALIGN_LEFT | wx.EXPAND | wx.ALL, 3)
		self.Container.GetSizer().Add(self.Password, (5, 7), (1, 20), wx.ALIGN_LEFT | wx.EXPAND | wx.ALL, 3)
		self.Container.GetSizer().Add(self.LoginButton, (6, 7), (1, 1), wx.ALL, 3)
		self.Container.GetSizer().Add(wx.StaticLine(self.Container), (8, 0), (1, 31), wx.EXPAND)
		self.Container.GetSizer().Add(wx.StaticText(self.Container, -1, '(C) 2011, Genie Information Systems, All Rights Reserved'), (10, 6), (1, 31), wx.EXPAND | wx.ALIGN_CENTER)
		self.LoginButton.Bind(wx.EVT_BUTTON, globalVars['EventHandler'].OnLogin, self.LoginButton)

	def Reset(self):
		self.Username.SetValue('')
		self.Password.SetValue('')

