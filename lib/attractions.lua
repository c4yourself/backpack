local City = require("lib.city")
-- @module attraction
local attractions = {}

attractions.attraction = { paris = {
                                    {name = "The Eiffel Tower",
                                    question = "How tall is the Eiffel Tower?",
                                    answers = {"324 metres", "564 metres", "137 metres", "401 metres"},
                                    pic_url = "data/images/CityTourEiffelTower.png",
                                    text = {"The Eiffel Tower is named after the engineer Gustave Eiffel, whose ",
                                            "company designed and built the tower. It was finished in 1889 and",
                                            "it is a global cultural icon of France and one of the most recognisable",
                                            "structures in the world. Around 6.98 million people visited the Eiffel",
                                            "Tower in 2011. The tower is 324 metres tall and Its base is 125 metres",
                                            "wide. The Eiffel Tower was the tallest man-made structure in the",
                                            "world for 41 years. Today it is the second-tallest structure in France.",
                                            " The tower has three levels for visitors, with restaurants on the first",
                                            "and second. The third level observatory's upper platform is 276 m",
                                            "above the ground. The climb from ground level to the first level is",
                                            "over 300 steps."}
                                  },
                                    {name = "Arc de Triomphe",
                                    question = "when was Arc de Triomphe finished?",
                                    answers = {"1836", "2001", "1993", "700"},
                                    pic_url = "data/images/CityTourEiffelTower.png",
                                    text = {"One of the most famous monuments in Paris is called Arc de",
                                            "Triomphe. It was designed by Jean Chalgrin and built between 1806",
                                            "and 1836. Visitors can admire its delicate design and engravings.",
                                            "The monument is 50 meters 45 meters wide and 22 meters deep.",
                                            "The Arc de Triomphe provides a glimpse into France’s social past as",
                                            "well as spectacular views across central Paris. It has four",
                                            "mainsculptural groups on each pillar depicting Le Départ de 1792,",
                                            "Le Triomphe de 1810, La Résistance de 1814 and La Paix 1815. On",
                                            "inside of the arch pillars names of military leaders of the French",
                                            "Revolution and Empire are engraved."}
                                    },
                                    {name = "Les Invalides",
                                    question = "Who of the following is buried here?",
                                    answers = {"Napoleon Bonaparte", "Gustave Eiffel", "Jean Chalgrin", "Philippe Pétain"},
                                    pic_url = "data/images/CityTourEiffelTower.png",
                                    text = {"Les Invalides is officially known as L'Hôtel national des Invalides (The National Residence of the Invalids). It is a complex of buildings in the 7th arrondissement of Paris, France containing museums and monuments, all relating to the military history of France. It also contains a hospital and a retirement home for war veterans. The buildings house the Musée de l'Armée, the military museum of the Army of France, the Musée des Plans-Reliefs, and the Musée d'Histoire Contemporaine, as well as the Dôme des Invalides, a large church with the burial site for some of France's war heroes, most notably Napoleon Bonaparte. The architect of Les Invalides was Libéral Bruant. The project was initiated by Louise XIV in an order dated 24 November 1670, as a home and hospital for aged and unwell soldiers."}
                                  }
                              },
                            cairo = {
                                    {name = "The Eiffel Tower",
                                    question = "How tall is the Eiffel Tower?",
                                    answers = {"324 metres", "564 metres", "137 metres", "401 metres"},
                                    pic_url = "data/images/CityTourEiffelTower.png",
                                    text = {"The Eiffel Tower is named after the engineer Gustave Eiffel, whose ",
                                            "company designed and built the tower. It was finished in 1889 and",
                                            "it is a global cultural icon of France and one of the most recognisable",
                                            "structures in the world. Around 6.98 million people visited the Eiffel",
                                            "Tower in 2011. The tower is 324 metres tall and Its base is 125 metres",
                                            "wide. The Eiffel Tower was the tallest man-made structure in the",
                                            "world for 41 years. Today it is the second-tallest structure in France.",
                                            " The tower has three levels for visitors, with restaurants on the first",
                                            "and second. The third level observatory's upper platform is 276 m",
                                            "above the ground. The climb from ground level to the first level is",
                                            "over 300 steps."}
                                  },
                                    {name = "Arc de Triomphe",
                                    question = "How deep is the monument?",
                                    answers = {"45 metres", "22 metres", "10 metres", "30 metres"},
                                    pic_url = "data/images/CityTourEiffelTower.png",
                                    text = {"One of the most famous monuments in Paris is called Arc de",
                                            "Triomphe. It was designed by Jean Chalgrin and built between 1806",
                                            "and 1836. Visitors can admire its delicate design and engravings.",
                                            "The monument is 50 meters 45 meters wide and 22 meters deep.",
                                            "The Arc de Triomphe provides a glimpse into France’s social past as",
                                            "well as spectacular views across central Paris. It has four",
                                            "mainsculptural groups on each pillar depicting Le Départ de 1792,",
                                            "Le Triomphe de 1810, La Résistance de 1814 and La Paix 1815. On",
                                            "inside of the arch pillars names of military leaders of the French",
                                            "Revolution and Empire are engraved."}
                                    },
                                    {name = "Les Invalides",
                                    question = "What is the monument related to?",
                                    answers = {"Military history", "Food history", "C4yourself history", "No history"},
                                    pic_url = "data/images/CityTourEiffelTower.png",
                                    text = {"Les Invalides is officially known as L'Hôtel national des Invalides (The National Residence of the Invalids). It is a complex of buildings in the 7th arrondissement of Paris, France containing museums and monuments, all relating to the military history of France. It also contains a hospital and a retirement home for war veterans. The buildings house the Musée de l'Armée, the military museum of the Army of France, the Musée des Plans-Reliefs, and the Musée d'Histoire Contemporaine, as well as the Dôme des Invalides, a large church with the burial site for some of France's war heroes, most notably Napoleon Bonaparte. The architect of Les Invalides was Libéral Bruant. The project was initiated by Louise XIV in an order dated 24 November 1670, as a home and hospital for aged and unwell soldiers."}
                                  }
                                },
                              rio_de_janeiro = {
                                          {name = "The Eiffel Tower",
                                          question = "How tall is the Eiffel Tower?",
                                          answers = {"324 metres", "564 metres", "137 metres", "401 metres"},
                                          pic_url = "data/images/CityTourEiffelTower.png",
                                          text = {"The Eiffel Tower is named after the engineer Gustave Eiffel, whose ",
                                                  "company designed and built the tower. It was finished in 1889 and",
                                                  "it is a global cultural icon of France and one of the most recognisable",
                                                  "structures in the world. Around 6.98 million people visited the Eiffel",
                                                  "Tower in 2011. The tower is 324 metres tall and Its base is 125 metres",
                                                  "wide. The Eiffel Tower was the tallest man-made structure in the",
                                                  "world for 41 years. Today it is the second-tallest structure in France.",
                                                  " The tower has three levels for visitors, with restaurants on the first",
                                                  "and second. The third level observatory's upper platform is 276 m",
                                                  "above the ground. The climb from ground level to the first level is",
                                                  "over 300 steps."}
                                        },
                                          {name = "Arc de Triomphe",
                                          question = "How deep is the monument?",
                                          answers = {"45 metres", "22 metres", "10 metres", "30 metres"},
                                          pic_url = "data/images/CityTourEiffelTower.png",
                                          text = {"One of the most famous monuments in Paris is called Arc de",
                                                  "Triomphe. It was designed by Jean Chalgrin and built between 1806",
                                                  "and 1836. Visitors can admire its delicate design and engravings.",
                                                  "The monument is 50 meters 45 meters wide and 22 meters deep.",
                                                  "The Arc de Triomphe provides a glimpse into France’s social past as",
                                                  "well as spectacular views across central Paris. It has four",
                                                  "mainsculptural groups on each pillar depicting Le Départ de 1792,",
                                                  "Le Triomphe de 1810, La Résistance de 1814 and La Paix 1815. On",
                                                  "inside of the arch pillars names of military leaders of the French",
                                                  "Revolution and Empire are engraved."}
                                          },
                                          {name = "Les Invalides",
                                          question = "What is the monument related to?",
                                          answers = {"Military history", "Food history", "C4yourself history", "No history"},
                                          pic_url = "data/images/CityTourEiffelTower.png",
                                          text = {"Les Invalides is officially known as L'Hôtel national des Invalides (The National Residence of the Invalids). It is a complex of buildings in the 7th arrondissement of Paris, France containing museums and monuments, all relating to the military history of France. It also contains a hospital and a retirement home for war veterans. The buildings house the Musée de l'Armée, the military museum of the Army of France, the Musée des Plans-Reliefs, and the Musée d'Histoire Contemporaine, as well as the Dôme des Invalides, a large church with the burial site for some of France's war heroes, most notably Napoleon Bonaparte. The architect of Les Invalides was Libéral Bruant. The project was initiated by Louise XIV in an order dated 24 November 1670, as a home and hospital for aged and unwell soldiers."}
                                        }
                                      },

                                    mumbai = {
                                          {name = "Gateway of India",
                                          question = "How high is the arch of the strucutre?",
                                          answers = {"26 metres", "32 metres", "50 metres", "15 metres"},
                                          pic_url = "data/images/CityTourEiffelTower.png",
                                          text = {"The Gateway of India is a monument built during the British Rule in",
                                                  "Mumbai City of Maharashtra state in Western India. The Gateway of India",
                                                  "was built to commemorate the visit of King George V and Queen Mary to",
                                                  "Mumbai, prior to the Delhi Durbar, in December 1911. However, they only",
                                                  "got to see a cardboard model of the structure since the construction",
                                                  "did not begin til 1915. It is located on the waterfron in the Apollo",
                                                  "Bunder area in South Mubai nad overlooks the Arabian sea. The structure",
                                                  "is a basalt arch, 26 metres (85 feet) high. It lies at the end of",
                                                  "Chhatrapati Shivaji Marg at the water's edge in Mumbai Harbor. It was",
                                                  "a crude jetty used by the fishing community which was later renovated",
                                                  "and used as a landing place for British governors and other prominent",
                                                  "people. In earlier times, it would have been the first structure that",
                                                  "visitors arriving by boat in Mumbai would have seen."
                                                  }
                                        },
                                          {name = "Haji Ali Daragah",
                                          question = "According to legends, Haji Ali once jabbed a finger into the soil making what gush out?",
                                          answers = {"Oil", "Gold", "Water", "Wine"},
                                          pic_url = "data/images/CityTourEiffelTower.png",
                                          text = {"The Haji Ali Dargah was constructed in 1431 in memory of a wealthy",
                                                  "Muslim merchant, Sayyed Peer Haji Ali Shah Bukhari, who gave up all",
                                                  "his worldly possessions before making a pilgrimage to Mecca. Hailing",
                                                  "from Bukhara, in present day Uzbekistan, Bukhari travelled around the",
                                                  "world in the early to mid 15th century, and eventually settled in",
                                                  "present day Mumbai. According to legends surrounding his life, he",
                                                  "once saw a poor woman crying on the road, holding an empty vessel. He",
                                                  "asked her what the problem was, she sobbed that her husband would",
                                                  "thrash her as she stumbled and accidentally spilled the oil she was",
                                                  "carrying. He asked her to take him to the spot where she spilt the",
                                                  "oil. There, he jabbed a finger into the soil and the oil gushed out.",
                                                  "The overjoyed woman filled up the vessel and went home. Haji Ali died",
                                                  "during his journey to Mecca and miraculously the casket carrying his",
                                                  "body, floated back to these shores, getting stuck in the string of",
                                                  "rocky islets just off the shore of Worli. Thus, the Dargah was",
                                                  "constructed there, on a tiny islet located 500 meters from the coast,",
                                                  "in the middle of Worli Bay."}
                                          },
                                          {name = "Chhatrapati Shivaju Terminus",
                                          question = "How many years did it take to build the station?",
                                          answers = {"10", "12", "8", "14"},
                                          pic_url = "data/images/CityTourEiffelTower.png",
                                          text = {"Chhatrapati Shivaji Terminus (previously Victoria Terminus) is a",
                                                  "UNESCO World Heritage historic railway station in Mumbai Maharashtra,",
                                                  "India which serves as the headquarters of the Central Railways. The",
                                                  "station took ten years to complete, the longest for any building of",
                                                  "that era in Bombay. Designed by Frederick William Stevens with",
                                                  "influences from Victorian Italianate Gothic Revival architecture",
                                                  "and traditional Mughal buildings, the station was built in 1887 in",
                                                  "the Bori Bunder area of Mumbai to commemorate the Golden Jubilee of",
                                                  "Queen Victoria. Stevens earned the commission to construct the station",
                                                  "after a masterpiece watercolor sketch by draughtsman Axel Haig. The new",
                                                  "railway station was built on the location of the Bori Bunder Station",
                                                  "and is one of the busiest railway stations in India"}
                                        }
                                      },

                                london = {
                                          {name = "The Eiffel Tower",
                                          question = "How tall is the Eiffel Tower?",
                                          answers = {"324 metres", "564 metres", "137 metres", "401 metres"},
                                          pic_url = "data/images/CityTourEiffelTower.png",
                                          text = {"The Eiffel Tower is named after the engineer Gustave Eiffel, whose ",
                                                  "company designed and built the tower. It was finished in 1889 and",
                                                  "it is a global cultural icon of France and one of the most recognisable",
                                                  "structures in the world. Around 6.98 million people visited the Eiffel",
                                                  "Tower in 2011. The tower is 324 metres tall and Its base is 125 metres",
                                                  "wide. The Eiffel Tower was the tallest man-made structure in the",
                                                  "world for 41 years. Today it is the second-tallest structure in France.",
                                                  " The tower has three levels for visitors, with restaurants on the first",
                                                  "and second. The third level observatory's upper platform is 276 m",
                                                  "above the ground. The climb from ground level to the first level is",
                                                  "over 300 steps."}
                                        },
                                          {name = "Arc de Triomphe",
                                          question = "How deep is the monument?",
                                          answers = {"45 metres", "22 metres", "10 metres", "30 metres"},
                                          pic_url = "data/images/CityTourEiffelTower.png",
                                          text = {"One of the most famous monuments in Paris is called Arc de",
                                                  "Triomphe. It was designed by Jean Chalgrin and built between 1806",
                                                  "and 1836. Visitors can admire its delicate design and engravings.",
                                                  "The monument is 50 meters 45 meters wide and 22 meters deep.",
                                                  "The Arc de Triomphe provides a glimpse into France’s social past as",
                                                  "well as spectacular views across central Paris. It has four",
                                                  "mainsculptural groups on each pillar depicting Le Départ de 1792,",
                                                  "Le Triomphe de 1810, La Résistance de 1814 and La Paix 1815. On",
                                                  "inside of the arch pillars names of military leaders of the French",
                                                  "Revolution and Empire are engraved."}
                                          },
                                          {name = "Les Invalides",
                                          question = "What is the monument related to?",
                                          answers = {"Military history", "Food history", "C4yourself history", "No history"},
                                          pic_url = "data/images/CityTourEiffelTower.png",
                                          text = {"Les Invalides is officially known as L'Hôtel national des Invalides (The National Residence of the Invalids). It is a complex of buildings in the 7th arrondissement of Paris, France containing museums and monuments, all relating to the military history of France. It also contains a hospital and a retirement home for war veterans. The buildings house the Musée de l'Armée, the military museum of the Army of France, the Musée des Plans-Reliefs, and the Musée d'Histoire Contemporaine, as well as the Dôme des Invalides, a large church with the burial site for some of France's war heroes, most notably Napoleon Bonaparte. The architect of Les Invalides was Libéral Bruant. The project was initiated by Louise XIV in an order dated 24 November 1670, as a home and hospital for aged and unwell soldiers."}
                                        }
                                      },


                                new_york = {
                                          {name = "The Eiffel Tower",
                                          question = "How tall is the Eiffel Tower?",
                                          answers = {"324 metres", "564 metres", "137 metres", "401 metres"},
                                          pic_url = "data/images/CityTourEiffelTower.png",
                                          text = {"The Eiffel Tower is named after the engineer Gustave Eiffel, whose ",
                                                  "company designed and built the tower. It was finished in 1889 and",
                                                  "it is a global cultural icon of France and one of the most recognisable",
                                                  "structures in the world. Around 6.98 million people visited the Eiffel",
                                                  "Tower in 2011. The tower is 324 metres tall and Its base is 125 metres",
                                                  "wide. The Eiffel Tower was the tallest man-made structure in the",
                                                  "world for 41 years. Today it is the second-tallest structure in France.",
                                                  " The tower has three levels for visitors, with restaurants on the first",
                                                  "and second. The third level observatory's upper platform is 276 m",
                                                  "above the ground. The climb from ground level to the first level is",
                                                  "over 300 steps."}
                                        },
                                          {name = "Arc de Triomphe",
                                          question = "How deep is the monument?",
                                          answers = {"45 metres", "22 metres", "10 metres", "30 metres"},
                                          pic_url = "data/images/CityTourEiffelTower.png",
                                          text = {"One of the most famous monuments in Paris is called Arc de",
                                                  "Triomphe. It was designed by Jean Chalgrin and built between 1806",
                                                  "and 1836. Visitors can admire its delicate design and engravings.",
                                                  "The monument is 50 meters 45 meters wide and 22 meters deep.",
                                                  "The Arc de Triomphe provides a glimpse into France’s social past as",
                                                  "well as spectacular views across central Paris. It has four",
                                                  "mainsculptural groups on each pillar depicting Le Départ de 1792,",
                                                  "Le Triomphe de 1810, La Résistance de 1814 and La Paix 1815. On",
                                                  "inside of the arch pillars names of military leaders of the French",
                                                  "Revolution and Empire are engraved."}
                                          },
                                          {name = "Les Invalides",
                                          question = "What is the monument related to?",
                                          answers = {"Military history", "Food history", "C4yourself history", "No history"},
                                          pic_url = "data/images/CityTourEiffelTower.png",
                                          text = {"Les Invalides is officially known as L'Hôtel national des Invalides (The National Residence of the Invalids). It is a complex of buildings in the 7th arrondissement of Paris, France containing museums and monuments, all relating to the military history of France. It also contains a hospital and a retirement home for war veterans. The buildings house the Musée de l'Armée, the military museum of the Army of France, the Musée des Plans-Reliefs, and the Musée d'Histoire Contemporaine, as well as the Dôme des Invalides, a large church with the burial site for some of France's war heroes, most notably Napoleon Bonaparte. The architect of Les Invalides was Libéral Bruant. The project was initiated by Louise XIV in an order dated 24 November 1670, as a home and hospital for aged and unwell soldiers."}
                                        }
                                      },

                                  tokyo = {
                                          {name = "The Eiffel Tower",
                                          question = "How tall is the Eiffel Tower?",
                                          answers = {"324 metres", "564 metres", "137 metres", "401 metres"},
                                          pic_url = "data/images/CityTourEiffelTower.png",
                                          text = {"The Eiffel Tower is named after the engineer Gustave Eiffel, whose ",
                                                  "company designed and built the tower. It was finished in 1889 and",
                                                  "it is a global cultural icon of France and one of the most recognisable",
                                                  "structures in the world. Around 6.98 million people visited the Eiffel",
                                                  "Tower in 2011. The tower is 324 metres tall and Its base is 125 metres",
                                                  "wide. The Eiffel Tower was the tallest man-made structure in the",
                                                  "world for 41 years. Today it is the second-tallest structure in France.",
                                                  " The tower has three levels for visitors, with restaurants on the first",
                                                  "and second. The third level observatory's upper platform is 276 m",
                                                  "above the ground. The climb from ground level to the first level is",
                                                  "over 300 steps."}
                                        },
                                          {name = "Arc de Triomphe",
                                          question = "How deep is the monument?",
                                          answers = {"45 metres", "22 metres", "10 metres", "30 metres"},
                                          pic_url = "data/images/CityTourEiffelTower.png",
                                          text = {"One of the most famous monuments in Paris is called Arc de",
                                                  "Triomphe. It was designed by Jean Chalgrin and built between 1806",
                                                  "and 1836. Visitors can admire its delicate design and engravings.",
                                                  "The monument is 50 meters 45 meters wide and 22 meters deep.",
                                                  "The Arc de Triomphe provides a glimpse into France’s social past as",
                                                  "well as spectacular views across central Paris. It has four",
                                                  "mainsculptural groups on each pillar depicting Le Départ de 1792,",
                                                  "Le Triomphe de 1810, La Résistance de 1814 and La Paix 1815. On",
                                                  "inside of the arch pillars names of military leaders of the French",
                                                  "Revolution and Empire are engraved."}
                                          },
                                          {name = "Les Invalides",
                                          question = "What is the monument related to?",
                                          answers = {"Military history", "Food history", "C4yourself history", "No history"},
                                          pic_url = "data/images/CityTourEiffelTower.png",
                                          text = {"Les Invalides is officially known as L'Hôtel national des Invalides (The National Residence of the Invalids). It is a complex of buildings in the 7th arrondissement of Paris, France containing museums and monuments, all relating to the military history of France. It also contains a hospital and a retirement home for war veterans. The buildings house the Musée de l'Armée, the military museum of the Army of France, the Musée des Plans-Reliefs, and the Musée d'Histoire Contemporaine, as well as the Dôme des Invalides, a large church with the burial site for some of France's war heroes, most notably Napoleon Bonaparte. The architect of Les Invalides was Libéral Bruant. The project was initiated by Louise XIV in an order dated 24 November 1670, as a home and hospital for aged and unwell soldiers."}
                                        }
                                      },

                                  sydney = {
                                          {name = "The Eiffel Tower",
                                          question = "How tall is the Eiffel Tower?",
                                          answers = {"324 metres", "564 metres", "137 metres", "401 metres"},
                                          pic_url = "data/images/CityTourEiffelTower.png",
                                          text = {"The Eiffel Tower is named after the engineer Gustave Eiffel, whose ",
                                                  "company designed and built the tower. It was finished in 1889 and",
                                                  "it is a global cultural icon of France and one of the most recognisable",
                                                  "structures in the world. Around 6.98 million people visited the Eiffel",
                                                  "Tower in 2011. The tower is 324 metres tall and Its base is 125 metres",
                                                  "wide. The Eiffel Tower was the tallest man-made structure in the",
                                                  "world for 41 years. Today it is the second-tallest structure in France.",
                                                  " The tower has three levels for visitors, with restaurants on the first",
                                                  "and second. The third level observatory's upper platform is 276 m",
                                                  "above the ground. The climb from ground level to the first level is",
                                                  "over 300 steps."}
                                        },
                                          {name = "Arc de Triomphe",
                                          question = "How deep is the monument?",
                                          answers = {"45 metres", "22 metres", "10 metres", "30 metres"},
                                          pic_url = "data/images/CityTourEiffelTower.png",
                                          text = {"One of the most famous monuments in Paris is called Arc de",
                                                  "Triomphe. It was designed by Jean Chalgrin and built between 1806",
                                                  "and 1836. Visitors can admire its delicate design and engravings.",
                                                  "The monument is 50 meters 45 meters wide and 22 meters deep.",
                                                  "The Arc de Triomphe provides a glimpse into France’s social past as",
                                                  "well as spectacular views across central Paris. It has four",
                                                  "mainsculptural groups on each pillar depicting Le Départ de 1792,",
                                                  "Le Triomphe de 1810, La Résistance de 1814 and La Paix 1815. On",
                                                  "inside of the arch pillars names of military leaders of the French",
                                                  "Revolution and Empire are engraved."}
                                          },
                                          {name = "Les Invalides",
                                          question = "What is the monument related to?",
                                          answers = {"Military history", "Food history", "C4yourself history", "No history"},
                                          pic_url = "data/images/CityTourEiffelTower.png",
                                          text = {"Les Invalides is officially known as L'Hôtel national des Invalides (The National Residence of the Invalids). It is a complex of buildings in the 7th arrondissement of Paris, France containing museums and monuments, all relating to the military history of France. It also contains a hospital and a retirement home for war veterans. The buildings house the Musée de l'Armée, the military museum of the Army of France, the Musée des Plans-Reliefs, and the Musée d'Histoire Contemporaine, as well as the Dôme des Invalides, a large church with the burial site for some of France's war heroes, most notably Napoleon Bonaparte. The architect of Les Invalides was Libéral Bruant. The project was initiated by Louise XIV in an order dated 24 November 1670, as a home and hospital for aged and unwell soldiers."}
                                        }
                                      },





                              }

return attractions
