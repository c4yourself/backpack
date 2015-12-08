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
                                            "Tower in 2011. The tower is 324 meters tall and its base is 125 meters",
                                            "wide. The Eiffel Tower was the tallest man-made structure in the",
                                            "world for 41 years. Today it is the second-tallest structure in France.",
                                            " The tower has three levels for visitors, with restaurants on the first",
                                            "and second. The third level observatory's upper platform is 276 m",
                                            "above the ground. The climb from ground level to the first level is",
                                            "over 300 steps."}
                                    },
                                    {name = "Arc de Triomphe",

                                    pic_url = "data/images/CityTourArcDeTriomphe.png",
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


                                    pic_url = "data/images/CityTourLesInvalides.png",
                                    text = {"Les Invalides is officially known as L'Hôtel national des Invalides",
                                            "It is a complex of buildings containing museums and",
                                            "monuments, all relating to the military history of France. It also",
                                            "contains a hospital and a retirement home for war veterans. The",
                                            "buildings house the Musée de l'Armée, the military museum of",
                                            "the Army of France, the Musée des Plans-Reliefs, and the Musée",
                                            "d'Histoire Contemporaine, as well as the Dôme des Invalides, a large",
                                            "church with the burial site for some of France's war heroes, most",
                                            "notably Napoleon Bonaparte. The architect of Les Invalides was",
                                            "Libéral Bruant. The project was initiated by Louise XIV in an order",
                                            "dated 24 November 1670, as a home and hospital for aged and",
                                            "unwell soldiers."}
                                  },
                                  {name = "Louvre",

                                  pic_url = "data/images/CityTourLouvre.png",
                                  text = {"The Louvre Palace or the Louvre Museum is one of the world's",
                                          "largest museums and a historic monument. Nearly 35,000 objects",
                                          "from prehistory to the 21st century are exhibited over an",
                                          "area of 60,600 square meters (652,300 square feet). The Louvre is",
                                          "the world's most visited museum, receiving more than 9.7 million",
                                          "visitors in 2012. The museum opened on 10 August 1793 with an",
                                          "exhibition of 537 paintings, the majority of the works being royal",
                                          "and confiscated church property. Because of structural problems",
                                          "with the building, the museum was closed in 1796 until 1801.",
                                          "The High Renaissance collection includes, Virgin and Child with ",
                                          "St. Anne, St. John the Baptist, and Madonna of the Rocks and The ",
                                          "Louvres most popular attraction, Leonardo da Vinci's Mona Lisa."
                                        }
                                  }
                          },

                          rio_de_janeiro = {
                                      {name = "Lagoa Neighborhood",

                                      pic_url = "data/images/CityTourLagoa.png",
                                      text = {"Lagoa (English: Lagoon) is a beautiful residential neighborhood in",
                                      "Rio de Janeiro, Brazil. It’s located around the Rodrigo deFreitas",
                                      "Lagoon and border to the neighborhoods of Ipanema, Leblon,",
                                      "Copacabana and Gávea. It is the third most expensive neighborhood",
                                      "to live in South America. It is also one of the few places in Rio de",
                                      "Janeiro without any bad neighborhood areas. The population is of",
                                      "about 18,200 inhabitants. Around the Rodrigo de Freitas Lagoon",
                                      "there is a 7.5 km long circle way and many parks. It would be mostly",
                                      "worth visiting for its stunning views, fantastic nature and ",
                                      "city complex. It attracts quite a number of visitors during the",
                                      "Christmas holidays due to its famous and gigantic Christmas tree,",
                                      " which is built over a floating platform that moves around the",
                                      "lagoon."}
                                      },
                                      {name = "Tijuca National Park",

                                      pic_url = "data/images/CityTourTijucaForest.png",
                                      text = {"The Tijuca Forest is a tropical rainforest in the city of Rio de Janeiro,",
                                      "Brazil. In 1961 Tijuca Forest was declared a National Park. The Forest",
                                      "contains a number of attractions, most notably the colossal",
                                      "sculpture of Christ the Redeemer on the top of Corcovado mountain.",
                                      "Other attractions include the Mayrink Chapel, with murals painted",
                                      "by Cândido Portinari, the light pagoda-style gazebo at Vista Chinesa",
                                      "outlook and the giant granite picnic table called the Mesa do",
                                      "Imperador. There are also 30 watersfalls within the forest with the",
                                      "most famous one being the Cascatinha Waterfall."}
                                      },
                                      {name = "Christ the Redeemer",

                                      pic_url = "data/images/CityTourChristTheRedeemer.png",
                                      text = {"Christ the Redeemer is an Art Deco statue of Jesus Christ in Rio",
                                      "de Janeiro, Brazil, created by French sculptor Paul Landowski and",
                                      "built by the Brazilian engineer Heitor da Silva Costa, in collaboration",
                                      "with the French engineer Albert Caquot. The face was created by",
                                      "the Romanian artist Gheorghe Leonida. The statue is 30 meters",
                                      "(98 feet) tall, not including its 8 meters (26 ft) pedestal, and its arms",
                                      "stretch 28 meters (92 feet) wide. It’s located at the peak of the",
                                      "700-metre (2,300 feet) Corcovado mountain in the Tijuca Forest",
                                      "National Park overlooking the city of Rio. A symbol of Christianity",
                                      "across the world, the statue has also, become a cultural icon of both",
                                      "Rio de Janeiro and Brazil, and is listed as one of the New Seven",
                                      "Wonders of the World."}
                                      },
                                      {name = "Copacabana beach",
                                      question = "Which ocean is the Copacabana beach located towards?",
                                      answers = {"The Atlantic", "The Pacific", "The Red Sea", "The Ocean of Brazil"},
                                      pic_url = "data/images/CityTourCopacabanaBeach.png",
                                      text = {"Copacabana beach is located at the Atlantic shore and is a",
                                      "staggering 4 km is length. There are historic forts at both ends of",
                                      "Copacabana beach; Fort Copacabana, built in 1914, is at the south",
                                      "end by Posto Seis and Fort Duque de Caxias, built in 1779, at the",
                                      "north end. Fort Copacabana, a military base with a wartime museum",
                                      "that is open to the public, stands at one end of the beach. On the",
                                      "length of beach fronting the fort, fishermen offer up their morning",
                                      "catch for sale. Aside for enjoying the beach the visitors can take",
                                      "a stroll along the promenade that borders the 4 km (2.5 mile) long",
                                      "beach. Originally built in the 1930s, the walkway features a wave-like",
                                      "design laid out in black and white stones."}
                                      }
                                  },

                                bombay = {
                                      {name = "Gateway of India",

                                      pic_url = "data/images/CityTourGatewayOfIndia.png",
                                      text = {"The Gateway of India is a monument built during the British Rule in",
                                              "Bombay to commemorate the visit of King George V and Queen",
                                              "Mary to Bombay, prior to the Delhi Durbar, in December 1911.",
                                              "However, they only got to see a cardboard model of the structure",
                                              "since the construction did not begin til 1915.The structure is a ",
                                              "basalt arch, 26 metres (85 feet) high. It lies at the end of Chhatrapati",
                                              "Shivaji Marg at the water's edge in Bombay Harbor. It was a crude",
                                              "jetty used by the fishing community which was later renovated and",
                                              "used as a landing place for British governors and other prominent",
                                              "people. In earlier times, it would have been the first structure that",
                                              "visitors arriving by boat in Bombay would have seen."
                                              }
                                    },
                                      {name = "Haji Ali Mosque/mausoleum",

                                      pic_url = "data/images/CityTourHajiAli.png",
                                      text = {"The Haji Ali Dargah was constructed in 1431 in memory of Sayyed",
                                              "Peer Haji Ali Shah Bukhari, who gave up all his worldly possessions",
                                              "before making a pilgrimage to Mecca. According to legends surrounding",
                                              "his life, he once saw a poor woman cryng on the road holding an empty",
                                              "vessel. He asked her what the problem was, she said that she had",
                                              "stumbled and accidently spilled the oil she was carrying. He asked her to",
                                              "take him to the spot where she spilt the oil. There, he jabbed a finger into",
                                              "the soil and the oil gushed out. The overjoyed woman filled up the vessel",
                                              "and went home. Haji Ali died during his journey to Mecca and the casket",
                                              "carrying his body, floated back to these shores, getting stuck in the string",
                                              "of rocky islet just off the shore of Worli. Thus, the Dargah was constructed",
                                              "there, on an islet 500 meters from the coast, in the middle of Wordli Bay."}
                                      },
                                      {name = "Chhatrapati Shivaju Terminus",

                                      pic_url = "data/images/CityTourVictoriaStation.png",
                                      text = {"Chhatrapati Shivaji Terminus (previously Victoria Terminus) is a",
                                              "UNESCO World Heritage historic railway station in  Maharashtra,",
                                              "India which serves as the headquarters of the Central Railways. The",
                                              "station took ten years to complete, the longest for any building of",
                                              "that era in Bombay. Designed by Frederick William Stevens with",
                                              "influences from Victorian Italianate Gothic Revival architecture and",
                                              "traditional Mughal buildings, the station was built in 1887 in the",
                                              "Bori Bunder area of Bombay to commemorate the Golden Jubilee of",
                                              "Queen Victoria. Stevens earned the commission to construct the",
                                              "station after a masterpiece watercolor sketch by draughtsman Axel",
                                              "Haig. The new railway station was built on the location of the Bori",
                                              "Bunder Station and is one of the busiest railway stations in India."}
                                    },
                                      {name = "Taj Mahal Palace & Tower",

                                      pic_url = "data/images/CityTourTajMahal.png",
                                      text = {"The Taj Mahal Palace Hotel is a five-star hotel located in the Colaba",
                                              "region of Bombay, Maharashtra,India, next to the Gateway of",
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
                                  },

                                london = {
                                          {name = "The Big Ben and Parliament",

                                          pic_url = "data/images/CityTourBigBen.png",
                                          text = {"Big Ben is the nickname for the Great Bell of the clock at the north",
                                          "end of the Palace of Westminster in London, and often extended to",
                                          "refer to the clock and the clock tower. The tower is officially known",
                                          "as Elizabeth Tower, renamed as such to celebrate the Diamond",
                                          "Jubilee of Elizabeth II (prior to being renamed in 2012 it was known",
                                          "simply as the Clock Tower). The tower holds the second largest",
                                          "four-faced chiming clock in the world. The tower was completed in",
                                          "1858 and had its 150th anniversary on 31 May 2009, during which",
                                          "celebratory events took place. The tower has become one of the",
                                          "most prominent symbols of the United Kingdom and is often in the",
                                          "establishing shot of films set in London."}
                                        },
                                        {name = "British Museum",

                                        pic_url = "data/images/CityTourBritishMuseum.png",
                                        text = {"The British Museum is a museum dedicated to human history, art,",
                                                "and culture, located in the Bloomsbury area of London. Its",
                                                "permanent collection, numbering some 8 million works, is among",
                                                "the largest and most comprehensive in existence and originates",
                                                "from all continents, illustrating and documenting the story of ",
                                                "human culture from its beginnings to the present. British Museum",
                                                "was established in 1753, largely based on the collections of the",
                                                "physician and scientist Sir Hans Sloane. The museum first opened to",
                                                "the public on 15 January 1759 in Montagu House in Bloomsbury, on",
                                                "the site of the current museum building."}
                                        },
                                          {name = "Tower of London",

                                          pic_url = "data/images/CityTourTowerOfLondon.png",
                                          text = {"Her Majesty's Royal Palace and Fortress, known as the Tower of",
                                                  "London, is a historic castle located on the north bank of the River",
                                                  "Thames in central London. It was founded towards the end of 1066",
                                                  "as part of the Norman Conquest of England. The Tower of London",
                                                  "has played a prominent role in English history. It was besieged",
                                                  "several times and controlling it has been important to controlling",
                                                  "the country. The Tower has served variously as an armory, a",
                                                  "treasury, a menagerie, the home of the Royal Mint, a public records",
                                                  "office, and the home of the Crown Jewels of England."}
                                          },
                                            {name = "Buckingham Palace",

                                            pic_url = "data/images/CityTourBuckinghamPalace.png",
                                            text = {"Buckingham Palace is the London residence and principal workplace",
                                                    "of the reigning monarch of the United Kingdom. Located in the City",
                                                    "of Westminster, the palace is often at the center of state occasions",
                                                    "and royal hospitality. It has been a focus for the British people at",
                                                    "times of national rejoicing. Originally known as Buckingham House,",
                                                    "the building which forms the core of today's palace was a large",
                                                    "townhouse built for the Duke of Buckingham in 1703 on a site which",
                                                    "had been in private ownership for at least 150 years. It was",
                                                    "subsequently acquired by King George III in 1761 as a private",
                                                    "residence for Queen Charlotte and was known as The Queen's",
                                                    "House."}
                                            }
                                      },


                                new_york = {
                                          {name = "The Statue of Liberty",

                                          pic_url = "data/images/CityTourStatueOfLiberty.png",
                                          text = {"The Statue of Liberty is a colossal neoclassical sculpture on Liberty",
                                                  "Island in New York Harbor in New York City, in the United States. The",
                                                  "copper statue, designed by Frédéric Auguste Bartholdi, a French",
                                                  "sculptor, was built by Gustave Eiffel in France and dedicated on",
                                                  "October 28, 1886.It was a gift to the United States from the people",
                                                  "of France. The statue is of a robed female figure representing",
                                                  "Libertas, the Roman goddess, who bears a torch and a tabula ansata",
                                                  "(a tablet evoking the law) upon which is inscribed the date of the",
                                                  "American Declaration of Independence, July 4, 1776. A broken chain",
                                                  "lies at her feet. The statue is an icon of freedom and of the United",
                                                  "States, and was a welcoming sight to immigrants arriving from",
                                                  "abroad. The copper statue is 46 meters tall and the whole statue",
                                                  "including the foundation is a total of 93 meters."}
                                          },
                                          {name = "The Empire State Building",

                                          pic_url = "data/images/CityTourEmpireStateBuilding.png",
                                          text = {"The Empire State Building is a 102-story skyscraper located in",
                                                  "Midtown Manhattan, New York City, on Fifth Avenue between West",
                                                  "33rd and 34th Streets. It has a roof height of 1,250 feet (381 meters),",
                                                  "and with its antenna spire included, it stands a total of 1,454 feet",
                                                  "(443 meters) tall. Its name is derived from the nickname for New",
                                                  "York, the Empire State. Following the September 11 attacks in 2001,",
                                                  "the Empire State Building was again the tallest building in New York,",
                                                  "until One World Trade Center reached a greater height in April 2012.",
                                                  "The Empire State Building is currently the fifth-tallest completed",
                                                  "skyscraper in the United States and the 29th-tallest in the world. It",
                                                  "is also the fifth-tallest freestanding structure in the Americas.",
                                                  "When measured by pinnacle height, it is the fourth-tallest building in",
                                                  "the United States."}
                                          },
                                          {name = "Times Square",

                                          pic_url = "data/images/CityTourTimesSquare.png",
                                          text = {"Times Square is a major commercial intersection and neighborhood",
                                                  "in Midtown Manhattan, New York City, at the junction of Broadway",
                                                  "and Seventh Avenue, and stretching from West 42nd to West 47th",
                                                  "Streets. Brightly adorned with billboards and advertisements, Times",
                                                  "Square is sometimes referred to as The Crossroads of the World, The",
                                                  "Center of the Universe and the Heart of the World. Times Square is",
                                                  "the site of the annual New Year's Eve ball drop. About one million",
                                                  "revelers crowd Times Square for the New Year's celebrations. It is",
                                                  "also the hub of the Broadway Theater District and a major center of",
                                                  "the world's entertainment industry. Approximately 330,000 people",
                                                  "pass through Times Square daily, many of them tourists, making it",
                                                  "one of the most visited tourist attractions in the world."}
                                          },
                                          {name = "Central park",

                                          pic_url = "data/images/CityTourCentralPark.png",
                                          text = {"Central Park is an urban park in middle-upper Manhattan, New York",
                                                  "City. Central Park is the most visited urban park in the United States",
                                                  "as well as one of the most filmed locations in the world. It opened in",
                                                  "1857 on 778 acres (315 ha) of city-owned land. In 1858, Frederick",
                                                  "Law Olmsted and Calvert Vaux, two soon-to-be famed national",
                                                  "landscapers and architects, won a design competition to improve",
                                                  "and expand the park with a plan they titled the Greensward Plan. It",
                                                  "was designated a National Historic Landmark in 1962. The Park was",
                                                  "managed for decades by the New York City Department of",
                                                  "Recreation and Parks and is currently managed by the non-profit",
                                                  "organization Central Park Conservancy under contract with the",
                                                  "municipal government in a public-private partnership. A total of 29",
                                                  "sculptures can be find throughout the park."}
                                          }
                                      },

                                  tokyo = {
                                          {name = "Tokyo Skytree",

                                          pic_url = "data/images/CityTourTokyoSkytree.png",
                                          text = {"The Tokyo Skytree is a broadcasting, restaurant, and observation",
                                                  "tower in Tokyo. It became the tallest structure in Japan in 2010 and",
                                                  "reached its full height of 634 meters (2080 feet) in March 2011,",
                                                  "making it the tallest tower in the world, displacing the Canton Tower,",
                                                  "and the second tallest structure in the world after the Burj Khalifa",
                                                  "(830 meters/2722 feet). It was completed on 29 February 2012, ",
                                                  "with the tower opening to the public on 22 May 2012."}
                                        },
                                          {name = "Sensōji Temple",

                                          pic_url = "data/images/CityTourSensojiTemple.png",
                                          text = {"Sensō-ji is an ancient Buddhist temple located in Asakusa, Tokyo,",
                                                  "Japan. It is Tokyo's oldest temple, and one of its most significant",
                                                  "Sensō-ji is the focus of Tokyo's largest and most popular festival",
                                                  "Sanja Matsuri. This takes place over 3–4 days in late spring, and",
                                                  "sees the surrounding streets closed to traffic from dawn until late",
                                                  "evening. Many tourists visit Sensō-ji every year, the surrounding",
                                                  "area has many traditional shops and eating places that feature",
                                                  "traditional dishes (hand-made noodles, sushi, tempura, etc.). During",
                                                  "World War II, the temple was bombed and destroyed. It was rebuilt",
                                                  "later and is a symbol of rebirth and peace to the Japanese people."}
                                          },
                                          {name = "Tokyo Disneyland",

                                          pic_url = "data/images/CityTourTokyoDisneyland.png",
                                          text = {"Tokyo Disneyland is a 115-acre (47 ha) theme park at near Tokyo.",
                                                  "The park has seven themed areas. They are the World Bazaar, the",
                                                  "four classic Disneylands called Adventureland, Western land,",
                                                  "Fantasyland and Tomorrowland and two mini-lands named Critter",
                                                  "Country and Mickey's Toon town. In 2013, Tokyo Disneyland hosted",
                                                  "17.2 million visitors, making it the world's second-most visited",
                                                  "theme park behind the Magic Kingdom at Walt Disney World Resort."}
                                          },
                                          {name = "Tokyo Tower",

                                          pic_url = "data/images/CityTourTokyoTower.png",
                                          text = {"Tokyo Tower is a communications and observation tower located in",
                                                  "Tokyo, Japan. At 333 meters (1092 feet), it is the second tallest",
                                                  "structure in Japan. Built in 1958, the tower's main sources of",
                                                  "revenue are tourism and antenna leasing. Around 150 million",
                                                  "people have visited the tower since its opening. The first floors",
                                                  "main attractions are the elevators that serve as a direct ride to the",
                                                  "Main Observatory. The third floor is home to the Guinness World",
                                                  "records Museum in Tokyo. On the roof of the Foot Town building",
                                                  "there’s a small amusement park that contains several small rides",
                                                  "and hosts live performances for children."}
                                          }
                                      },

                                  sydney = {
                                          {name = "Sydney Opera House",

                                          pic_url = "data/images/CityTourSydneyOperaHouse.png",
                                          text = {"The Sydney Opera House is a multi-venue performing arts center in",
                                                  "Sydney, Australia. It is situated on Bennelong Point in Sydney",
                                                  "Harbor, close to the Sydney Harbor Bridge, and adjacent to the",
                                                  "Sydney central business district and the Royal Botanic Gardens,",
                                                  "between Sydney Cove and Farm Cove. Designed by Danish architect",
                                                  "Jørn Utzon, the building was formally opened on 20 October 1973,",
                                                  "by Queen Elizabeth II. Though its name suggests a single venue,",
                                                  "the building comprises performance venues which together are",
                                                  "among the busiest performing arts centers in the world—hosting",
                                                  "over 1,500 performances each year attended by some 1.2 million",
                                                  "people."}
                                        },
                                          {name = "Sydney Tower",

                                          pic_url = "data/images/CityTourSydneyTower.png",
                                          text = {"Sydney Tower is Sydney's tallest structure and the second tallest",
                                                  "observation tower in the Southern Hemisphere. The tower stands 309",
                                                  "meters (1014 feet) above the Sydney central business district,",
                                                  "located on Market Street, between Pitt and Castlereagh Streets. The",
                                                  "tower is open to the public, and is one of the most prominent",
                                                  "tourist attractions in the city, being visible from a number of",
                                                  "vantage points throughout town and from adjoining suburbs. Designed",
                                                  "by Australian architect Donald Crone the first plans for Sydney",
                                                  "Tower were unveiled in March 1968. Construction of the office",
                                                  "building commenced in 1970, and tower construction began in 1975.",
                                                  "Public access to the tower began in August 1981."}
                                          },
                                          {name = "The Queen Victoria Building",

                                          pic_url = "data/images/CityTourQueenVictoriaBuilding.png",
                                          text = {"The Queen Victoria Building (or QVB), is a late nineteenth-century",
                                                  "building architect George McRae in the central business district",
                                                  "of Sydney, Australia. The Romanesque Revival building was",
                                                  "constructed between 1893 and 1898 and is 30m (98ft) wide by 190m",
                                                  "(620ft) long. The building fills a city block bounded by George,",
                                                  "Market, York and Druitt Streets. Designed as a marketplace, it was",
                                                  "used for a variety of other purposes, underwent re-modelling and",
                                                  "suffered decay until its restoration and return to its original",
                                                  "use in the late twentieth century."}
                                          },
                                          {name = "The Harbour Bridge",

                                          pic_url = "data/images/CityTourQueenHarbourBridge.png",
                                          text = {"The Sydney Harbour Bridge is a bridge across Sydney Harbor that",
                                                  "carries rail, vehicular, bicycle, and pedestrian traffic. The",
                                                  "dramatic view of the bridge,the harbor, and the nearby Sydney Opera",
                                                  "House is an iconic image of Sydney, and Australia. The bridge is",
                                                  "nicknamed \"The Coathanger\" because of its arch-based design or is",
                                                  "simply called \"The Bridge\" by Sydney residents. Under the direction",
                                                  "of Dr J.J.C. Bradfield of the NSW Department of Public Works, the",
                                                  "bridge was designed and built by British firm Dorman Long and Co Ltd",
                                                  "of Middlesbrough and opened in 1932. The bridge's design was",
                                                  "influenced by the Hell Gate Bridge in New York City. One of the",
                                                  "ongoing tourist attractions of the bridge has been the south-east",
                                                  "pylon, which is accessed via the pedestrian walkway across the",
                                                  "bridge, and then a climb to the top of the pylon of about 200",
                                                  "steps."}
                                                }
                                        },


                                  cairo = {
                                         {name = "Pyramid of Giza",

                                         pic_url = "data/images/CityTourPyramidOfGiza.png",
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

                                          pic_url = "data/images/CityTourEgyptianMuseum.png",
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
                                          question = "What is the name of the prophet of Islam?",
                                          answers = {"Mohammad", "Ali", "Al-Azhar", "Fatimah"},
                                          pic_url = "data/images/CityTourAlAzhar.png",
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
                                        
                                          pic_url = "data/images/CityTourTheCitadel.png",
                                          text = {"The Citadel was fortified by the Ayyubid ruler Salah al-Di (Saladin)",
                                                  "between 1176 and 1183 CE, to protect it from the Crusaders.",
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
                                  }

}

return attractions
