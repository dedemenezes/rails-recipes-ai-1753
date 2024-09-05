
Recipe.destroy_all

Recipe.create(name: "Guacamole", ingredients: "avocado,cilantro,lime")
Recipe.create(name: "Ratatouille", ingredients: "eggplant,zucchini,bell pepper")

User.create! email: 'hermione@grange.wb', password: 123456
