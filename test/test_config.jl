using Blink
using MLExps
using Interact
w = Window()
columnbuttons = Observable{Any}(dom"div"())
fields = Vector{MLExps.ParamField}()
a = MLExps.create_new_fieldbox(w,fields)
# on(x->begin add_new_field(newfield[]); update_window!(w,fields_array); end,validate)
# body!(w,vbox(newfield,validate))
body!(w,a)
# ASDA, Int: 1;3;2
MLExps.update_window!(w,fields)
