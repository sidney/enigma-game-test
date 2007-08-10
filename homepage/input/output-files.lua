----------------------------------------------------------------------
-- General options
----------------------------------------------------------------------

directory = "input/"
newsdir = "input/news/"
suffix = ".html"

language_list = {"", "_de", "_ru"} -- "_fr"

-- The newsfield declares the news (by number) to be shown on the main page.

newsfield = {16, 17, 18, 19, 20, 21}

-- General $$mystring$$-macros. Strings are taken as-is, tables are
-- constellations of html input files, functions are executed, with the
-- following syntax: 
--   function(v,s,l0)  ...  end
--     v = the current field (like html.index), mostly equals the file
--     s = "mystring" itself (as a string -> selfreferential!)
--    l0 = language code (see language_list: "" is English, "_de" German)

general = {
    infile = directory.."schema"..suffix,
    charset = "ISO-8859-1",
    charset_ru = "KOI8-R",
    lang = "",
    lang_de = "_de",
    lang_fr = "_fr",
    lang_ru = "_ru",
    title = "Enigma Homepage",
    title_de = "Enigma Hauptseite",
    --fr-- title_fr = "Enigma Homepage",
    --ru-- title_ru = "Enigma Homepage",
    refman = "manual/enigma-ref.html",
    manual = "manual/enigma.html",
    manual_de = "manual/enigma_de.html",
    manual_fr = "manual/enigma_fr.html",
    manual_ru = "manual/enigma_ru.html", -- existing?
    wiki = "http://enigma.mal2.ch/index.php?title=Main_Page",
    wiki_de = "http://enigma.mal2.ch/index.php?title=Hauptseite",
    disclaimer = "http://www.disclaimer.de/disclaimer.htm#2",
    disclaimer_de = "http://www.disclaimer.de/disclaimer.htm#1",
    gpl = "http://www.gnu.org/licenses/licenses.html#GPL",
    same_en = function(v,s,l0)  return add_lang_to_filename(v.outfile, "")     end,
    same_de = function(v,s,l0)  return add_lang_to_filename(v.outfile, "_de")  end,
    same_fr = function(v,s,l0)  return add_lang_to_filename(v.outfile, "_fr")  end,
    same_ru = function(v,s,l0)  return add_lang_to_filename(v.outfile, "_ru")  end,
    navbar = {"navbar"},
    leftcolumn = {"menu","validation"},
    rightcolumn = {},
    body = {},
    bottombar = {"bottombar"},
    parse_news_1 = function(v,s,l0)
        return parse_text(v, parse_news(newsdir,l0,newsfield), l0, "news1")
      end,
    parse_news_2 = function(v,s,l0)
        return parse_text(v, parse_news(newsdir,l0), l0, "news2")
      end,
    parse_lotm_by_rating = function(v,s,l0)
        return parse_text(v, parse_lotm("current_rating", true, l0), l0,
          add_lang_to_filename(v.outfile, l0))
      end,
    parse_lotm_chronological = function(v,s,l0)
        return parse_text(v, parse_lotm("chronological", false, l0), l0,
          add_lang_to_filename(v.outfile, l0))
      end,
    parse_lotm_by_position = function(v,s,l0)
        return parse_text(v, parse_lotm("position_num", false, l0), l0,
          add_lang_to_filename(v.outfile, l0))
    end,
    lotm_archive_data_from = function(v,s,l0)
        return lotm_archive_date(l0)
      end,
    lotm_expansion = "Level of the Month",
    lotm_expansion_de = "Level des Monats",
    lotm_header = {"lotm/lotm_header"},
    --ru-- lotm_expansion_ru = "Level of the Month",
    January   = function(v,s,l0)  return  translate_month(l0, {month=1})  end,
    February  = function(v,s,l0)  return  translate_month(l0, {month=2})  end,
    March     = function(v,s,l0)  return  translate_month(l0, {month=3})  end,
    April     = function(v,s,l0)  return  translate_month(l0, {month=4})  end,
    May       = function(v,s,l0)  return  translate_month(l0, {month=5})  end,
    June      = function(v,s,l0)  return  translate_month(l0, {month=6})  end,
    July      = function(v,s,l0)  return  translate_month(l0, {month=7})  end,
    August    = function(v,s,l0)  return  translate_month(l0, {month=8})  end,
    September = function(v,s,l0)  return  translate_month(l0, {month=9})  end,
    October   = function(v,s,l0)  return  translate_month(l0, {month=10})  end,
    November  = function(v,s,l0)  return  translate_month(l0, {month=11})  end,
    December  = function(v,s,l0)  return  translate_month(l0, {month=12})  end,
    imagedir    = "images",
    imagedir_de = "images",
    imagedir_fr = "images",
    imagedir_ru = "images",
    lastupdate = "$Date$",
    lastauthor = "$Author$",
    lastrev = "$Rev$"
}

----------------------------------------------------------------------
-- Date translation
----------------------------------------------------------------------

date_translation_field = {
  months = {"January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"},
  months_de = {"Januar", "Februar", "M&auml;rz", "April", "Mai", "Juni",
    "Juli", "August", "September", "Oktober", "November", "Dezember"}
}

--------------------------------------------------------------------------------

----------------------------------------------------------------------
-- index.html
----------------------------------------------------------------------
html.index = {
    outfile = "index.html",
    title = "Enigma Homepage",
    title_de = "Enigma Hauptseite",
    --ru-- title_ru = "Enigma Homepage",
    rightcolumn = {"infobox"},
    body = {"introduction", "intro-links", "news1", "powered-by"}
}

----------------------------------------------------------------------
-- about.html
----------------------------------------------------------------------
html.about = {
    outfile = "about.html",
    title = "About Enigma",
    title_de = "&Uuml;ber Enigma",
    --ru-- title_ru = "About Enigma",
    body = {"about", "features", "testimonials", "press"}
}

----------------------------------------------------------------------
-- news.html
----------------------------------------------------------------------
html.news = {
    outfile = "news.html",
    title = "News and Olds",
    title_de = "Neues und Altes",
    --ru-- title_ru = "News and Olds",
    rightcolumn = {},
    body = {"news2"}
}

----------------------------------------------------------------------
-- screenshots.html
----------------------------------------------------------------------
html.screenshots = {
    outfile = "screenshots.html",
    title = "Screenshots of Enigma",
    title_de = "Screenshots von Enigma",
    --ru-- title_ru = "Screenshots of Enigma",
    body = {"screenshots"}
}

----------------------------------------------------------------------
-- credits.html
----------------------------------------------------------------------
html.credits = {
    outfile = "credits.html",
    title = "Credits",
    title_de = "Credits",
    --ru-- title_ru = "Credits",
    body = {"credits"}
}

--------------------------------------------------------------------------------
----------------------------------------------------------------------
-- download.html
----------------------------------------------------------------------
html.download = {
    outfile = "download.html",
    title = "Download Enigma",
    title_de = "Enigma herunterladen",
    --ru-- title_ru = "Download Enigma",
    body = {"download"}
}

--------------------------------------------------------------------------------
----------------------------------------------------------------------
-- support.html
----------------------------------------------------------------------
html.support = {
    outfile = "support.html",
    title = "User-Support",
    title_de = "Spieler-Support",
    --ru-- title_ru = "User-Support",
    body = {"support"} --{"scores", "documentation"}
}


----------------------------------------------------------------------
-- faq.html
----------------------------------------------------------------------
html.faq = {
    outfile = "faq.html",
    title = "Frequently Asked Questions",
    title_de = "H&auml;ufig gestellte Fragen",
    --ru-- title_ru = "Frequently Asked Questions",
    body = {"faq_core", "faq_questions"}
}

----------------------------------------------------------------------
-- statistics.html
----------------------------------------------------------------------
html.statistics = {
    outfile = "statistics.html",
    title = "User Statistics",
    title_de = "Spieler-Statistiken",
    --ru-- title_ru = "User Statistics",
    average = "average",
    average_de = "Durchschnitt",
    --ru-- average_ru = "average",
    count = "count",
    count_de = "Anzahl",
    --ru-- count_ru = "count",
    user = "user",
    user_de = "Spieler",
    --ru-- user_ru = "user",
    solved_hcp = "solved hcp",
    solved_hcp_de = "gel&ouml;stes hcp",
    --ru-- solved_hcp_ru = "solved hcp",
    difficult = "difficult",
    difficult_de = "schwer",
    --ru-- difficult_ru = "difficult",
    easy = "easy",
    easy_de = "leicht",
    --ru-- easy_ru = "easy",
    total = "total",
    total_de = "gesamt",
    --ru-- total_ru = "total",
    shared = "shared",
    shared_de = "geteilt",
    --ru-- shared_ru = "shared",
    rating = "rating",
    rating_de = "Bewertung",
    --ru-- rating_ru = "rating",
    Handicap_Statistics = "Handicap Statistics of",
    Handicap_Statistics_de = "Handicap-Statistiken vom",
    --ru-- Handicap_Statistics_ru = "Handicap Statistics of", -- (month)
    Rating_Statistics = "Rating Statistics of",
    Rating_Statistics_de = "Bewertungs-Statistiken vom",
    --ru-- Rating_Statistics = "Rating Statistics of", -- (month)
    Solved_Level_Statistics = "Solved Level Statistics of",
    Solved_Level_Statistics_de = "Statistik der gel&ouml;sten Levels vom",
    --ru-- Solved_Level_Statistics_ru = "Solved Level Statistics of", -- (month)
    Worldrecord_Statistics = "Worldrecord Statistics of",
    Worldrecord_Statistics_de = "Weltrekord-Statistik vom",
    --ru-- Worldrecord_Statistics_ru = "Worldrecord Statistics of", -- (month)
    Other_Statistics = "Other Statistics",
    Other_Statistics_de = "Weitere Statistiken",
    --ru-- Other_Statistics_ru = "Other Statistics",
    Scores = "Scores",
    Scores_de = "Ergebnisse",
    --ru-- Scores_ru = "Scores",
    Ratings = "Ratings",
    Ratings_de = "Bewertungen",
    --ru-- Ratings_ru = "Ratings",
    single_level_scores = "single level scores have been registered.",
    single_level_scores_de = "einzelne Levelscores wurden registriert.",
    --ru-- single_level_scores_ru = "single level scores have been registered.",
    single_level_ratings = "single level ratings have been registered with an average of",
    single_level_ratings_de = "einzelne Levelbewertungen wurden registriert, mit einem Durchschnitt von",
    --ru-- single_level_ratings_ru = "single level ratings have been registered with an average of",
    and_distribution = "and the following distribution:",
    and_distribution_de = "und der folgenden Verteilung:",
    --ru-- and_distribution_ru = "and the following distribution:",
    names_in_use = "Names in use:",
    names_in_use_de = "Vergebene Namen:",
    --ru-- names_in_use_ru = "Names in use:",
    leftcolumn = {"menu", "validation", "userlist"},
    rightcolumn = {},
    body = {"stat-head", "table-wr", "table-solved", "stat-help",
            "table-hcp", "stat-other", "table-rat", "stat-tail"}
}

--------------------------------------------------------------------------------
----------------------------------------------------------------------
-- development.html
----------------------------------------------------------------------
html.development = {
    outfile = "devel.html",
    title = "Development",
    title_de = "Entwicklung",
    --ru-- title_ru = "Development",
    body = {"development"}
}

--------------------------------------------------------------------------------
----------------------------------------------------------------------
-- links.html
----------------------------------------------------------------------
html.links = {
    outfile = "links.html",
    title = "Links",
    title_de = "Links",
    --ru-- title_ru = "Links",
    body = {"links"}
}

----------------------------------------------------------------------
-- impressum.html
----------------------------------------------------------------------
html.impressum = {
    outfile = "impressum.html",
    title = "Impressum",
    title_de = "Impressum",
    --ru-- title_ru = "Impressum",
    body = {"impressum", "longline"}
}

--------------------------------------------------------------------------------

----------------------------------------------------------------------
-- LotM - Archive Pages
----------------------------------------------------------------------

html.lotm = {
    outfile = "lotm.html",
    title = "$$lotm_expansion$$",
    rightcolumn = {},
    body = {"lotm/lotm_core"}
}

html.lotm_chronological = {
    outfile = "lotm_chronological.html",
    title = "$$lotm_expansion$$ (chronological)",
    title_de = "$$lotm_expansion$$ (chronologisch)",
    --ru-- title_ru = "$$lotm_expansion$$ (chronological)",
    rightcolumn = {},
    body = {"lotm/lotm_chronological"}
}

html.lotm_by_position = {
    outfile = "lotm_by_position.html",
    title = "$$lotm_expansion$$ (by position)",
    title_de = "$$lotm_expansion$$ (nach Position)",
    --ru-- title_ru = "$$lotm_expansion$$ (by position)",
    rightcolumn = {},
    body = {"lotm/lotm_by_position"}
}

