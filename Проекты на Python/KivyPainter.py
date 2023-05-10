from kivy.app import App
from kivy.uix.widget import Widget
from kivy.uix.button import Button

from random import random
from kivy.core.window import Window
from kivy.graphics import (Color, Ellipse, Rectangle, Line)


class PainterWidget(Widget):
    # def __init__(self, **kwargs):
    #    super(PainterWidget, self).__init__(**kwargs)

    def on_touch_down(self, touch):
        with self.canvas:
            Color(random(), random(), random(), 1)
            rad = 30
            # Ellipse(pos=(100, 100), size=(50, 50))
            # Line(points=(100, 100, 150, 200, 200, 100), close=True, width=5)
            # self.line = Line(points=(), width=10, joint='bevel')
            Ellipse(pos=(touch.x - rad / 2, touch.y - rad / 2), size=(rad, rad))
            touch.ud['Line'] = Line(points=(touch.x, touch.y), width=rad / 2)

    def on_touch_move(self, touch):
        touch.ud['Line'].points += (touch.x, touch.y)

    # def on_touch_down(self, touch):
    #    self.line.points += (touch.x, touch.y)


class PaintApp(App):
    def build(self):
        parent = Widget()
        self.painter = PainterWidget()
        parent.add_widget(self.painter)

        parent.add_widget(Button(text='Clear', on_press=self.clear_canvas, size=(100, 50)))
        parent.add_widget(Button(text='Save', on_press=self.save, size=(100, 50), pos=(100, 0)))
        parent.add_widget(Button(text='Screen', on_press=self.screen, size=(100, 50), pos=(200, 0)))

        return parent

    def clear_canvas(self, instance):
        self.painter.canvas.clear()

    def save(self, instance):
        self.painter.size = (Window.size[0], Window.size[1])
        self.painter.export_to_png('image.png')

    def screen(self, instance):
        Window.screenshot('screen.png')


if __name__ == '__main__':
    PaintApp().run()
