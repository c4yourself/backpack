local City = require("lib.city")
-- @module attraction
local attractions = {}

attractions.attraction = {
    paris = {
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
                    "over 300 steps."
                  }
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
                    "Revolution and Empire are engraved."
                  }
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
                     "unwell soldiers."
                   }
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
                  "Louvres most popular attraction, Leonardo da Vinci's Mona Lisa."
                }
          }
    },

    cairo = {
           {name = "Pyramid of Giza", pic_url = "data/images/CityTourEiffelTower.png",
                text = {"The Great Pyramid of Giza (also known as the Pyramid ",
                        "of Khufu or the Pyramid of Cheops) is the oldest and largest of",
                        "the three pyramids in the Giza pyramid complex bordering what is",
                        "now El Giza, Egypt. It is the oldest one in the list of the Seven",
                        "Wonders of the Ancient World, and the only one to remain largely",
                        "intact. Based on a mark in an interior chamber naming the work",
                        "gang and a reference to fourth dynasty Egyptian Pharaoh Khufu,",
                        "Egyptologists believe that the pyramid was built as a tomb over a",
                        "10 to 20-year period concluding around 2560 BC."
                      }
            },
            {name = "Egyptian museum",
            pic_url = "data/images/CityTourEiffelTower.png",
            text = {"The Museum of Egyptian Antiquities, known commonly as the",
                     "Egyptian Museum or Museum of Cairo, in Cairo, Egypt, is home to",
                     "an extensive collection of ancient Egyptian antiquities. It has",
                     "120,000 items, with a representative amount on display, the",
                     "remainder in storerooms. During the Egyptian Revolution of 2011,",
                     "the museum was broken into, and two mummies were reportedly",
                     "destroyed. Several artifacts were also shown to have been damaged.",
                     "Around 50 objects were lost. Since then 25 objects have been found,",
                       "as of October 2015, it is open to the public."
                     }
            },
            {name = "Al-Azhar mosque",
            pic_url = "data/images/CityTourEiffelTower.png",
            text = {"Al-Azhar (mosque of the most resplendent) is a mosque in Islamic",
                    "Cairo in Egypt. Al-Mu'izz li-Din Allah of the Fatimid Caliphate",
                    "commissioned its construction for the newly established capital city",
                    "in 970. Its name is usually thought to allude to the Islamic prophet",
                    "Muhammad's daughter Fatimah, a revered figure in Islam who was",
                    "given the title az-Zahrā′ (the shining or resplendent one). It was the",
                    "first mosque established in Cairo, a city that has since gained the",
                    "nickname the City of a Thousand Minarets."
                  }
            },
            {name = "The Citadel",
            pic_url = "data/images/CityTourEiffelTower.png",
            "(Saladin) between 1176 and 1183 CE, to protect it from the Crusaders.",
            text = {"The Citadel was fortified by the Ayyubid ruler Salah al-Di (Saladin)",
                    "Only a few years after defeating the Fatimid Caliphate, Saladin",
                    "set out to build a wall that would surround both Cairo and Fustat.",
                    "Saladin is recorded as saying, With a wall I will make the two ",
                    "(cities of Cairo and Fustat) into a unique whole, so that one army ",
                    "may defend them both; and I believe it is good to encircle them",
                    "with a single wall from the bank of the Nile to the bank of the ",
                    "Nile”. The Citadel would be the centerpiece ofthe wall. It is now a",
                    "preserved historic site, with mosques and museums."
                  }
            }
    },

    mumbai = {
            {name = "Gateway of India",
            pic_url = "data/images/CityTourEiffelTower.png",
            text = {"The Gateway of India is a monument built during the British Rule",
                    "in Mumbai City of Maharashtra state in Western India. The Gateway",
                    "of India was built to commemorate the visit of King George V and",
                    "Queen Mary to Mumbai, prior to the Delhi Durbar, in December",
                    "1911. However they only got to see a cardboard model of the ",
                    "structure since the construction did not begin till 1915. It is located",
                    "on the waterfront in the Apollo Bunder area in South Mumbai and",
                    "overlooks the Arabian Sea. The structure is a basalt arch, 26 meters",
                    "(85 feet) high. It lies at the end of Chhatrapati Shivaji Marg at the",
                    "water's edge in Mumbai Harbor. It was a crude jetty used by the ",
                    "fishing community which was later renovated and used as a landing",
                    "place for British governors and other prominent people. In earlier",
                    "times, it would have been the first structure that visitors",
                    "arriving by boat in Mumbai would have seen."
                  }
          },
          {name = "Haji Ali Mosque/mausoleum",
          pic_url = "data/images/CityTourEiffelTower.png",
          text = {"The Haji Ali Dargah was constructed in 1431 in memory of a",
                  "wealthy Muslim merchant, Sayyed Peer Haji Ali Shah Bukhari, who ",
                  "gave up all his worldly possessions before making a pilgrimage to",
                  "Mecca. Hailing  from Bukhara, in present day Uzbekistan, Bukhari",
                  "travelled around the world in the early to mid 15th century, and",
                  "eventually settled in present day Mumbai. According to legends",
                  "surrounding his life, he once saw a poor woman crying on the road,",
                  "holding an empty vessel. He asked her what the problem was, she",
                  "sobbed that her husband would thrash her as she stumbled and ",
                  "accidentally spilled the oil she was carrying. He asked her to take ",
                  "him to the spot where she spilt the oil. There, he jabbed a finger ",
                  "into the soil and the oil gushed out. The overjoyed woman filled up",
                  "the vessel and went home. Haji Ali died during his journey to",
                  "Mecca and miraculously the casket carrying his body, floated back",
                  "to these shores, getting stuck in the string of rocky islets just",
                  "off the shore of Worli. Thus, the Dargah was constructed there, on a",
                  "tiny islet located 500 meters from the coast, in the middle of",
                  "Worli Bay."
                }
          },
          {name = "Chhatrapati Shivaji Terminus",
          pic_url = "data/images/CityTourEiffelTower.png",
          text = {"Chhatrapati Shivaji Terminus (previously Victoria Terminus) is a",
                  "UNESCO World Heritage Site and an historic railway station in",
                  "Mumbai Maharashtra, India which serves as the headquarters of",
                  "the Central Railways. The station took ten years to complete, the",
                  "longest for any building of that era in Bombay. Designed by",
                  "Frederick William Stevens with influences from Victorian Italianate",
                  "Gothic Revival architecture and traditional Mughal buildings, the",
                  "station was built in 1887 in the Bori Bunder area of Mumbai to",
                  "commemorate the Golden Jubilee of Queen Victoria. Stevens earned",
                  "the commission to construct the station after a masterpiece",
                  "watercolor sketch by draughtsman Axel Haig. The new railway",
                  "station was built on the location of the Bori Bunder Station and is",
                  "one of the busiest railway stations in India."
                }
          },
          {name = "Taj Mahal Palace & Tower",
          pic_url = "data/images/CityTourEiffelTower.png",
          text = {"The Taj Mahal Palace Hotel is a five-star hotel located in the Colaba";
                  "region of Mumbai, Maharashtra,India, next to the Gateway of",
                  "India. The hotel's original building first opened its doors to guests",
                  "on 16 December 1903. Part of the Taj Hotels, Resorts and Palaces,",
                  "this hotel is considered the flagship property of the Tata group and",
                  "contains 560 rooms and 44 suites and 11 restaurants. From a",
                  "historical and architectural point of view, the two buildings that",
                  "make up the hotel, the Taj Mahal Palace and the Tower are two",
                  "distinct buildings, built at different times and in different",
                  "architectural designs."
                }
          }
    }

}

return attractions
