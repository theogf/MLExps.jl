using Blink
using MLExps
using Interact
w = Window()
fields = Vector{MLExps.ParamField}()
o = Observable{Any}(dom"div"())
a = MLExps.create_new_fieldbox(fields,o)
# on(x->begin add_new_field(newfield[]); update_window!(w,fields_array); end,validate)
# body!(w,vbox(newfield,validate))
body!(w,a)
# ASDA, Int: 1;3;2
MLExps.update_window!(w,fields,o)
