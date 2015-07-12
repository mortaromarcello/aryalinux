import wx

app = wx.PySimpleApp()
f = wx.Frame(None, -1, title='Testing Date')
f.SetSizer(wx.GridBagSizer())
d = wx.DatePickerCtrl(f, -1)
f.GetSizer().Add(d, (0, 0), (1, 1), wx.EXPAND)
f.GetSizer().AddGrowableCol(0)
f.Show()
app.MainLoop()
