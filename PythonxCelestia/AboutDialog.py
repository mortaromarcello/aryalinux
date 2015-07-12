import wx
import ButtonPanel as bp

class AboutDialog(wx.Dialog):

	def __init__(self, parent):
		wx.Dialog.__init__(self, parent, -1, 'About Celestia')
		self.SetSizer(wx.BoxSizer(wx.VERTICAL))
		self.Initialize()
		button = wx.Button(self, -1, 'Ok')
		self.GetSizer().Add(button, 0, wx.ALL | wx.ALIGN_RIGHT, 5)
		button.Bind(wx.EVT_BUTTON, self.OnOk, button)
		self.SetSize(self.GetEffectiveMinSize())
		self.Center()
		self.ShowModal()

	def Initialize(self):
		BannerPic = wx.Image('splash.jpg', wx.BITMAP_TYPE_ANY).ConvertToBitmap()
		BannerPanel = wx.Panel(self, -1)
		BannerPanel.SetSizer(wx.BoxSizer(wx.VERTICAL))
		Banner = wx.StaticBitmap(BannerPanel, -1, BannerPic, (5, 5), (BannerPic.GetWidth(), BannerPic.GetHeight()))
		BannerPanel.GetSizer().Add(Banner, wx.ALIGN_RIGHT)
		BannerPanel.SetBackgroundColour(wx.Colour(0x41, 0x8d, 0x35))
		self.GetSizer().Add(BannerPanel, 0, wx.EXPAND)

	def OnOk(self, event):
		self.Destroy()


