#!/usr/bin/python

import wx
import pickle
import EntityWorkspace as eworkspace
import SearchWorkspace as sworkspace
import EventHandler as eh
import DashBoard as dash
import DataSource as ds
import CardPanel as cp
import LoginPanel as lp

class Application(wx.Frame):

	def __init__(self, profilePath, profileRef):
		wx.Frame.__init__(self, None, -1, title='Celestia ERP')

		self.GlobalVars = dict()
		self.GlobalVars['MainFrame'] = self
		self.GlobalVars['CurrentActionID'] = 100
		self.GlobalVars['Actions'] = dict()
		self.GlobalVars['WidgetStack'] = list()
		self.GlobalVars['ObjectListStack'] = list()
		self.GlobalVars['DataSourceStack'] = list()
		self.GlobalVars['ValueStack'] = list()
		self.GlobalVars['EventHandler'] = eh.EventHandler(self, self.GlobalVars)
		self.GlobalVars['Server'] = 'http://localhost/process.php'
		self.GlobalVars['DataSource'] = ds.DataSource(self.GlobalVars)

		self.ProfilePath = profilePath
		self.Profile = profileRef
		self.SetSizer(wx.BoxSizer(wx.VERTICAL))

		Application.App = self

		# Adding banner across the top
		BannerPic = wx.Image('logo2.jpg', wx.BITMAP_TYPE_ANY).ConvertToBitmap()
		BannerPanel = wx.Panel(self, -1)
		BannerPanel.SetSizer(wx.BoxSizer(wx.VERTICAL))
		Banner = wx.StaticBitmap(BannerPanel, -1, BannerPic, (5, 5), (BannerPic.GetWidth(), BannerPic.GetHeight()))
		BannerPanel.GetSizer().Add(Banner, wx.ALIGN_RIGHT)
		self.GetSizer().Add(BannerPanel, 0, wx.EXPAND)

		self.CardPanel = cp.CardPanel(self)
		self.GetSizer().Add(self.CardPanel, 1, wx.EXPAND)
		self.CreateStatusBar()

		self.Initialize()
		self.FinalShow()

	def Initialize(self):
		self.InitializeDashBoard()
		self.InitializeLoginScreen()
		self.InitializeProfile()

	def InitializeDashBoard(self):
		self.DashBoard = dash.DashBoard(self.CardPanel, self.GlobalVars)
		self.CardPanel.AddScreen(self.DashBoard, 'DASH_BOARD')

	def InitializeLoginScreen(self):
		self.LoginScreen = lp.LoginPanel(self.CardPanel, self.GlobalVars)
		self.CardPanel.AddScreen(self.LoginScreen, 'LOGIN_SCREEN')

	def InitializeProfile(self):
		if self.ProfilePath == None and self.Profile == None:
			print 'Profile cannot be initialized. Please contact administrator. Error : 0x0001'
			exit()
		elif self.ProfilePath != None:
			f = open(self.ProfilePath, 'r')
			self.Profile = pickle.load(f)
			self.GlobalVars['Database Properties'] = self.Profile['Database Properties']
		self.GlobalVars['DataSource'].Initialize(self.Profile['lstDatabase Table'])
		self.ProfileName = self.Profile['sProfile Name']
		self.InitializeNavigation()
		self.InitializeEntityWorkspaces()
		self.InitializeGraphs()
		self.InitializeSearchWorkspaces()
		self.InitializeViewWorkspaces()
		self.InitializeReports()

	def InitializeNavigation(self):
		navigation = self.Profile['lstMenu']
		Application.MenuBar = wx.MenuBar()
		for menu in navigation:
			m = wx.Menu()
			for item in menu['lstMenu Option']:
				if item['sOption Label'] == 'MENU_OPTION : -':
					m.AppendSeparator()
				else:
					it = wx.MenuItem(m, self.GlobalVars['CurrentActionID'], item['sOption Label'][14:])
					self.Bind(wx.EVT_MENU, self.GlobalVars['EventHandler'].DispatchAction, it)
					self.GlobalVars['Actions'][self.GlobalVars['CurrentActionID']] = item['sMenuoption Action'] + '/' + item['sTarget']
					self.GlobalVars['CurrentActionID'] = self.GlobalVars['CurrentActionID'] + 1
					m.AppendItem(it)
			Application.MenuBar.Append(m, menu['sMenu Name'][7:])
		pass

	def InitializeEntityWorkspaces(self):
		entityWorkspaces = self.Profile['lstEntity Workspace']
		for ew in entityWorkspaces:
			ewsp = eworkspace.EntityWorkspace(self.CardPanel)
			ewsp.Initialize(ew, self.GlobalVars)
			self.CardPanel.AddScreen(ewsp, ew['sEntity Workspace Name'])
		pass

	def InitializeGraphs(self):
		pass

	def InitializeSearchWorkspaces(self):
		searchWorkspaces = self.Profile['lstSearch Workspace']
		for sw in searchWorkspaces:
			swsp = sworkspace.SearchWorkspace(self.CardPanel)
			swsp.Initialize(sw, self.GlobalVars)
			self.CardPanel.AddScreen(swsp, sw['sSearch Workspace Name'])
		pass

	def InitializeViewWorkspaces(self):
		pass

	def InitializeReports(self):
		pass

	def Ready(self):
		pass

	def FinalShow(self):
		self.SwitchScreen('LOGIN_SCREEN')
		self.SetMenuBar(Application.MenuBar)
		self.SetSize((640, 400))
		self.Maximize()
		self.Center()
		# Now use profilePath as pickle source and read the profile file into Application.Profile

		# Initialize a CardPanel. This would be a static variable as in Application.ContentArea

		# Add a Login Screen to the CardPanel.

		# Render screens for the Profile and add them to the CardPanel

		# Initialize the Parameters to connect to the server

		# Initialize the DataSource

		# Initialize the Stacks :-

		# Initialize the WindowStack

		# Initialize the ObjectStack

	def SwitchScreen(self, ScreenName):
		# This would switch between screens and would be used by the Menu and other navigation methods to switch screens
		self.GlobalVars['MainFrame'].CardPanel.SwitchScreen(ScreenName)
		del self.GlobalVars['DataSourceStack'][:]
		del self.GlobalVars['WidgetStack'][:]
		del self.GlobalVars['ObjectListStack'][:]
		if ScreenName != 'DASH_BOARD':
			#print 'Resetting ' + ScreenName
			self.GlobalVars['MainFrame'].CardPanel.GetScreenByName(ScreenName).Reset()
			self.PushToDS(self.GlobalVars['MainFrame'].CardPanel.GetScreenByName(ScreenName))
		pass

	def PushToDS(self, ref):
		self.GlobalVars['DataSourceStack'].append(ref)

	def PushToWS(self, ref):
		self.GlobalVars['WidgetStack'].append(ref)

	def PushToVS(self, ref):
		self.GlobalVars['ValueStack'].append(ref)


	def PopDS(self):
		return self.GlobalVars['DataSourceStack'].pop()


	def PopWS(self):
		return self.GlobalVars['WidgetStack'].pop()


	def PopVS(self):
		return self.GlobalVars['ValueStack'].pop()

if __name__ == '__main__':
	app = wx.PySimpleApp()
	f = Application('../../Admin.prof', None)
	f.Show()
	app.MainLoop()

