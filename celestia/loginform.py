import wx
import sys
sys.path.append('.')
import okcanceldialog
import form

class LoginDialog(okcanceldialog.OkCancelDialog):
	def __init__(self, parent):
		super(LoginDialog, self).__init__(parent)
		self.LoginForm = form.Form(self.GetMainPanel())
		self.LoginForm.InitializeControls([{'label':'Email Address', 'type':'textfield'}, {'label':'Password', 'type':'password'}, {'type':'listbox', 'label':'Role', 'options':['Admin', 'User']}, {'type':'button', 'label':'', 'value':'Login'}])
		self.Add(self.LoginForm)

app = wx.App()
frame = wx.Frame(None)
frame.Show()
dialog = LoginDialog(frame)
dialog.SetSize((dialog.GetEffectiveMinSize().GetHeight() * 2.5, dialog.GetEffectiveMinSize().GetHeight()))
dialog.Show()
app.MainLoop()
