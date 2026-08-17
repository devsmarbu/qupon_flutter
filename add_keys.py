import json

with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
    en = json.load(f)

new_keys = {
  "filterAllTime": "All Time",
  "filterStatusActive": "Active",
  "filterStatusExpired": "Expired",
  "filterStatusPending": "Pending",
  "filterAll": "All",
  "filterDateLabel": "Date: ",
  "filterStatusLabel": "Status: ",
  "filterVendorLabel": "Vendor: ",
  "awaitingRedemption": "Awaiting Redemption",
  "redeemedLabel": "Redeemed",
  "shopByCategory": "Shop By Category",
  "electronicsLabel": "Electronics",
  "viewAllLabel": "View All",
  "qrDialogVendor": "Vendor",
  "qrDialogOffer": "Offer",
  "qrDialogStatus": "Status",
  "qrDialogOrderRef": "Order Ref",
  "qrDialogExpiry": "Expiry",
  "qrDialogRedeemCode": "Redeem Code",
  "qrDialogClose": "Close"
}

en.update(new_keys)

with open('lib/l10n/app_en.arb', 'w', encoding='utf-8') as f:
    json.dump(en, f, ensure_ascii=False, indent=2)

print("Added keys to app_en.arb")
