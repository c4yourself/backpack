local City = require("lib.city")
-- @module attraction
local attractions = {}

attractions.attraction = { paris = {
                                    {name = "The Eiffel Tower",
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
                                    pic_url = "data/images/CityTourEiffelTower.png",
                                    text = {"Les Invalides is officially known as L'Hôtel national des Invalides ",
                                            "(The National Residence of the Invalids). It is a complex of buildings",
                                            "in the 7th arrondissement of Paris, France containing museums and ",
                                            "monuments all relating to the military history of France. It also",
                                            "contains a hospital and a retirement home for war veterans. The ",
                                             "buildings house the Musée de l'Armée, the military museum of the ",
                                             "Army of France, the Musée des Plans-Reliefs, and the Musée",
                                             "d'Histoire Contemporaine, as well as the Dôme des Invalides, a large",
                                             "church with the burial site for some of France's war heroes, most",
                                             "notably Napoleon Bonaparte. The architect of Les Invalides was",
                                             "Libéral Bruant. The project was initiated by Louise XIV in an order",
                                             "dated 24 November 1670, as a home and hospital for aged and ",
                                             "unwell soldiers."}
                                  },
                                  {name = "Louvre",
                                  pic_url = "data/images/CityTourEiffelTower.png",
                                  text = {"The Louvre Palace or the Louvre Museum is one of the world's",
                                  "largest museums and a historic monument in Paris, France. Nearly",
                                  "35,000 objects from prehistory to the 21st century are exhibited over",
                                  "an area of 60,600 square meters (652,300 square feet). The Louvre is",
                                  "the world's most visited museum, receiving more than 9.7 million",
                                  "visitors in 2012. The museum opened on 10 August 1793 with an",
                                  "exhibition of 537 paintings, the majority of the works being royal",
                                  "and confiscated church property. Because of structural problems",
                                  "with the building, the museum was closed in 1796 until 1801. The",
                                  " collection was increased under Napoleon and the museum",
                                  "renamed the Musée Napoléon, but after Napoleon's abdication many",
                                  "works seized by his armies were returned to their original owners.",
                                  " The High Renaissance collection includes, Virgin and Child with ",
                                  "St. Anne, St. John the Baptist, and Madonna of the Rocks and The ",
                                  "Louvres most popular attraction, Leonardo da Vinci's Mona Lisa."}
                                }

                                },

                             cairo = {name = "Pyramid of Giza", pic_url = "data/images/CityTourEiffelTower.png",
                                    text = {"The Great Pyramid of Giza (also known as the Pyramid ",
                                    "of Khufu or the Pyramid of Cheops) is the oldest and largest of",
                                    "the three pyramids in the Giza pyramid complex bordering what is",
                                    "now El Giza, Egypt. It is the oldest one in the list of the Seven",
                                    "Wonders of the Ancient World, and the only one to remain largely",
                                    "intact. Based on a mark in an interior chamber naming the work",
                                    "gang and a reference to fourth dynasty Egyptian Pharaoh Khufu,",
                                    "Egyptologists believe that the pyramid was built as a tomb over a",
                                    "10 to 20-year period concluding around 2560 BC."}
                                  }

                              }

return attractions
