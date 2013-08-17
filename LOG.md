2013-08-17 - Afternoon
----------------------

Very beginnings, Started with classes and related skills. 

Most of the actual work this afternoon was on data loading (for internal data, not working data).

System data comes from CSV files in db/seed_tables.
The naming convention for this is:

numeric index, then the underscored, plural class name.
E.G. 01-character_classes.csv

Headers are methods to run on a newly created object:

* Those ending in = are set before saving the object
* Others are called afterwards (mostly to set relationships by name, after saving)

These are run at db:seeds, and the 'check' method on any model is called as you go. 

Check methods are a simple summary, but can also be used to weed out problems, which are then shown 
at the end of the seed loading. See app/models/character_class.rb for a strong pattern.

Hopefully, next time I`ll get closer to some game mechanics.

2013-08-17 - Evening
--------------------

This session was:
* putting in Character and it`s relationship to skills.
* Levelling up and aquiring skills (barely tested)
* Creating a very simple battle scenario (/test/unit/battle_test.rb)

This is actually a bit of a coup for me, that it`s reached this stage so quickly.
Eventually I hope to use range and speed, to make a dynamic, grid-based game, but this
is a definite step fowards. And it`s 11:41 on a Saturday night. Don`t forget that!