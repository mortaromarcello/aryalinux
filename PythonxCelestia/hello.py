import wx

class Test:

	def __init__(self):
		self.attributes = ["sName", "sAddress", "sPhone", "iAge", "fSalary"]


class ObjectEditor(wx.Dialog):

	def __init__(self, parent):
		wx.Dialog.__init__(self, parent, title="Object Editor")
		self.container = wx.Panel(self, -1)
		self.sizer = wx.GridBagSizer()
		self.container.SetSizer(self.sizer)
		self.sizer.AddGrowableCol(1);
		self.SetSizer(wx.GridBagSizer())
		self.GetSizer().Add(self.container, (0, 0), (1, 1), wx.EXPAND | wx.ALL, 20)
		self.GetSizer().AddGrowableRow(0);
		self.GetSizer().AddGrowableCol(0);

		self.buttonPanel = wx.Panel(self, -1)
		self.GetSizer().Add(wx.StaticLine(self, -1), (1, 0), (1, 1), wx.EXPAND | wx.LEFT | wx.RIGHT | wx.BOTTOM, 10)
		self.GetSizer().Add(self.buttonPanel, (2, 0), (1, 1), wx.LEFT | wx.RIGHT | wx.BOTTOM | wx.ALIGN_RIGHT, 10)
		self.buttonSizer = wx.GridSizer(1, 2)
		self.buttonPanel.SetSizer(self.buttonSizer)
		self.okButton = wx.Button(self.buttonPanel, -1, "Ok")
		self.cancelButton = wx.Button(self.buttonPanel, -1, "Cancel")
		self.buttonSizer.Add(self.okButton)
		self.buttonSizer.Add(self.cancelButton)

	def initialize(self, className):
		ref = className()
		controls = list()
		controlTypes = list()

		count = 0
		for attribute in ref.attributes:
			if attribute[0] == 'i':
				self.sizer.Add(wx.StaticText(self.container, -1, attribute[1:]), (count, 0), (1, 1), wx.ALIGN_RIGHT | wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 10)
				ctrl = wx.SpinCtrl(self.container, -1)
				controls.append(ctrl)
				self.sizer.Add(ctrl, (count, 1), (1, 1), wx.ALIGN_LEFT | wx.LEFT, 10)
			elif attribute[0] == 's':
				self.sizer.Add(wx.StaticText(self.container, -1, attribute[1:]), (count, 0), (1, 1), wx.ALIGN_RIGHT | wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 10)
				ctrl = wx.TextCtrl(self.container, -1)
				controls.append(ctrl)
				self.sizer.Add(ctrl, (count, 1), (1, 1), wx.ALIGN_LEFT | wx.LEFT | wx.EXPAND, 10)
			elif attribute[0] == 'f':
				self.sizer.Add(wx.StaticText(self.container, -1, attribute[1:]), (count, 0), (1, 1), wx.ALIGN_RIGHT | wx.ALIGN_CENTER_VERTICAL | wx.RIGHT, 10)
				ctrl = wx.TextCtrl(self.container, -1)
				controls.append(ctrl)
				self.sizer.Add(ctrl, (count, 1), (1, 1), wx.ALIGN_LEFT | wx.LEFT, 10)
			count = count + 1

		self.SetSize((self.GetEffectiveMinSize().height * 2, self.GetEffectiveMinSize().height))
		self.ShowModal()


app = wx.PySimpleApp()
p = wx.Frame(None, -1, title="Hello World")
p.Maximize()
p.Show()
o = ObjectEditor(p)
o.initialize(Test)
print "Done"
app.MainLoop()
