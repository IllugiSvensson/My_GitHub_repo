from kivy.app import App

from kivy.uix.button import Button
from kivy.uix.widget import Widget
from kivy.uix.label import Label
from kivy.uix.gridlayout import GridLayout
from kivy.uix.boxlayout import BoxLayout

from kivy.config import Config

Config.set('graphics', 'resizable', 0)
Config.set('graphics', 'width', 480)
Config.set('graphics', 'height', 640)


class CalculatorApp(App):
    def build(self):
        self.formula = '0'
        bl = BoxLayout(orientation='vertical', padding=3)
        gl = GridLayout(cols=4, spacing=3, size_hint=(1, .6))

        self.lbl = Label(text='0', font_size=40, size_hint=(1, .4), halign='right', valign='center',
                         text_size=(480 - 50, 640 / 2 - 50))
        bl.add_widget(self.lbl)

        for i in [7, 8, 9, 'x', 4, 5, 6, '-', 1, 2, 3, '+', '@', 0, '.', '=']:
            if type(i) == type(1):
                gl.add_widget(Button(text=str(i), on_press=self.add_number))
            elif type(i) == type('a'):
                if i == '=':
                    gl.add_widget(Button(text=str(i), on_press=self.calc_result))
                elif i == '@':
                    gl.add_widget(Widget())
                else:
                    gl.add_widget(Button(text=str(i), on_press=self.add_operation))

        bl.add_widget(gl)
        return bl

    def add_number(self, instance):
        if (self.formula == '0'):
            self.formula = ''
        self.formula += str(instance.text)
        self.update_label()

    def add_operation(self, instance):
        if (str(instance.text).lower() == "x"):
            self.formula += '*'
        else:
            self.formula += str(instance.text)
        self.update_label()

    def update_label(self):
        self.lbl.text = self.formula

    def calc_result(self, instance):
        self.lbl.text = str(eval(self.lbl.text))
        self.formula = "0"


if __name__ == "__main__":
    CalculatorApp().run()
