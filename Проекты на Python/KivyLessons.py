from kivy.app import App
from kivy.uix.button import Button
from kivy.uix.codeinput import CodeInput
from pygments.lexers import HtmlLexer
from kivy.config import Config
from kivy.uix.floatlayout import FloatLayout
from kivy.uix.scatter import Scatter
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.gridlayout import GridLayout
from kivy.uix.anchorlayout import AnchorLayout

Config.set('graphics', 'resizable', 0)
Config.set('graphics', 'width', 640)
Config.set('graphics', 'height', 480)

class MyApp(App):
    def build(self):
        #return CodeInput(lexer = HtmlLexer())
        s = Scatter()
        fl = FloatLayout(size=(300, 300))
        s.add_widget(fl)
        fl.add_widget(Button(text="This is button",
                      font_size=32,
                      on_press=self.btn_press,
                      background_color=[1, 0, 0, 1],
                      background_normal='',
                             size_hint = (.5, .25),
                             pos = (640 / 2 - 160, 480 / 2)))
        return s
    def btn_press(self, instance):
        print("Button pressed")
        instance.text = "Whoa"

class BoxApp(App):
    def build(self):
        bl = BoxLayout(orientation='horizontal', padding=[50, 25], spacing=10)
        bl.add_widget(Button(text="Button1"))
        bl.add_widget(Button(text="Button2"))
        bl.add_widget(Button(text="Button3"))
        return bl

class GridApp(App):
    def build(self):
        gl = GridLayout(cols = 3, padding=[25], spacing=10)
        for i in range(12):
            gl.add_widget(Button(text = str(i)))
        return gl

class AncApp(App):
    def build(self):
        al = AnchorLayout(anchor_x='left', anchor_y='center')
        al.add_widget(Button(text='Button1', size_hint=[.5, .5]))
        return al

if __name__ == "__main__":
    #MyApp().run()
    #BoxApp().run()
    #GridApp().run()
    AncApp().run()