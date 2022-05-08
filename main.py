import MeCab

text = "明日、スカイツリーに行く予定です。"
print(text)
print("----------------------")

m1 = MeCab.Tagger()
print(m1.parse(text))
print("----------------------")

m2 = MeCab.Tagger('-Owakati')
print(m2.parse(text))
