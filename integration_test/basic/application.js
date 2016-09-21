pipeline = Source({name:"mongodb"}).transform({filename:"transform.js",namespace:"."}).save({name:"elastic"})
