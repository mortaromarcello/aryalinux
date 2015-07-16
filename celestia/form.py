import wx
import sys
sys.path.append('.')
import okcancelpanel
import okcanceldialog

class Form(wx.Panel):
	def __init__(self, parent):
		super(Form, self).__init__(parent)
		self.SetSizer(wx.FlexGridSizer(0, 2, 1, 1))
		self.GetSizer().AddGrowableCol(1)

	def InitializeControls(self, controls):
		for control in controls:
			label = wx.StaticText(self, -1, control['label'])
			if control['type'] == 'textarea' or control['type'] == 'listbox':
				self.GetSizer().Add(label, 1, wx.ALIGN_TOP|wx.ALIGN_RIGHT|wx.ALL, 2)
			else:
                                self.GetSizer().Add(label, 1, wx.ALIGN_CENTER_VERTICAL|wx.ALIGN_RIGHT|wx.ALL, 2)

			if control['type'] == 'textfield':
				c = wx.TextCtrl(self, -1)
				self.GetSizer().Add(c, 1, wx.ALIGN_LEFT | wx.EXPAND | wx.ALL, 2)
			elif control['type'] == 'password':
                                c = wx.TextCtrl(self, -1, style=wx.TE_PASSWORD)                         
                                self.GetSizer().Add(c, 1, wx.ALIGN_LEFT | wx.EXPAND | wx.ALL, 2)
                        elif control['type'] == 'textarea':
                                c = wx.TextCtrl(self, -1, style=wx.TE_MULTILINE)
                                self.GetSizer().Add(c, 1, wx.ALIGN_LEFT | wx.EXPAND | wx.ALL, 2)
                        elif control['type'] == 'button':
                                c = wx.Button(self, -1, control['value'])
                                self.GetSizer().Add(c, 1, wx.ALIGN_LEFT | wx.ALL, 2)
                        elif control['type'] == 'checkbox':
                                c = wx.CheckBox(self, -1, control['value'])
                                self.GetSizer().Add(c, 1, wx.ALIGN_LEFT | wx.EXPAND | wx.ALL, 2)
                        elif control['type'] == 'combobox':
                                ctrl = wx.ComboBox(self, -1, style=wx.CB_READONLY)
                                self.GetSizer().Add(ctrl, 1, wx.ALIGN_LEFT | wx.EXPAND | wx.ALL, 2)
				if control['options'] != None:
					for option in control['options']:
						ctrl.Append(option)
					ctrl.Select(0)
                        elif control['type'] == 'listbox':
                                ctrl = wx.ListBox(self, -1)
                                self.GetSizer().Add(ctrl, 1, wx.ALIGN_LEFT | wx.EXPAND | wx.ALL, 2)
				if control['options'] != None:
                                        for option in control['options']:
                                                ctrl.Append(option)
                                        ctrl.Select(0)
		print "Done"

