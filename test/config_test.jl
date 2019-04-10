using MLExps
d=Dict("a"=>123,"b"=>[3,2])
write_config(Workspace("a","b"),d,"config","blaaah")
load_config(ExpConfig("config","blaaah",Dict()))
JSON.print(d)
