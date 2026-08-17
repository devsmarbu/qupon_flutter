import urllib.request
import json
import re

def to_camel_case(snake_str):
    components = snake_str.lower().split('_')
    return components[0] + ''.join(x.title() for x in components[1:])

req_en = urllib.request.Request('https://qupon.marbu.in/api/storefront/labels/1', headers={'User-Agent': 'Mozilla/5.0'})
resp_en = urllib.request.urlopen(req_en)
data_en = json.loads(resp_en.read().decode('utf-8'))['data']

req_ar = urllib.request.Request('https://qupon.marbu.in/api/storefront/labels/2', headers={'User-Agent': 'Mozilla/5.0'})
resp_ar = urllib.request.urlopen(req_ar)
data_ar = json.loads(resp_ar.read().decode('utf-8'))['data']

en_arb = {"@@locale": "en"}
ar_arb = {"@@locale": "ar"}

for k, v in data_en.items():
    camel_k = to_camel_case(k)
    en_arb[camel_k] = v
    ar_arb[camel_k] = data_ar.get(k, v)

with open('lib/l10n/app_en_new.arb', 'w', encoding='utf-8') as f:
    json.dump(en_arb, f, ensure_ascii=False, indent=2)

with open('lib/l10n/app_ar_new.arb', 'w', encoding='utf-8') as f:
    json.dump(ar_arb, f, ensure_ascii=False, indent=2)

print("Done")
