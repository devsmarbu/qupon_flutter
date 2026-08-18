import json

def merge_arb(base_file, new_file, output_file):
    with open(base_file, 'r', encoding='utf-8') as f:
        base_arb = json.load(f)
        
    with open(new_file, 'r', encoding='utf-8') as f:
        new_arb = json.load(f)
        
    for k, v in new_arb.items():
        if k != "@@locale":
            base_arb[k] = v
            
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(base_arb, f, ensure_ascii=False, indent=2)

merge_arb('lib/l10n/app_en.arb', 'lib/l10n/app_en_new.arb', 'lib/l10n/app_en.arb')
merge_arb('lib/l10n/app_ar.arb', 'lib/l10n/app_ar_new.arb', 'lib/l10n/app_ar.arb')
print("Merged successfully")
