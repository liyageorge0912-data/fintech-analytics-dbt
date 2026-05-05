"""
Fintech Credit Card Analytics - AE Portfolio Project
-----------------------------------------------------
Generates synthetic fintech dataset.
Four tables: customers, applications, transactions, credit_limit_history
"""

import csv
import random
import string
from datetime import date, timedelta

SEED = 42
random.seed(SEED)

# ── helpers ───────────────────────────────────────────────────────────────────

def random_id(prefix, n):
    return f"{prefix}_{''.join(random.choices(string.ascii_lowercase + string.digits, k=8))}"

def random_date(start, end):
    delta = (end - start).days
    return start + timedelta(days=random.randint(0, delta))

def write_csv(filename, headers, rows):
    with open(filename, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=headers)
        writer.writeheader()
        writer.writerows(rows)
    print(f"Written {len(rows)} rows to {filename}")

# ── configuration ─────────────────────────────────────────────────────────────

N_CUSTOMERS = 5000
START_DATE = date(2022, 1, 1)
END_DATE = date(2024, 12, 31)

COUNTRIES = ['UK', 'US', 'DE', 'FR', 'AU']
COUNTRY_WEIGHTS = [0.50, 0.20, 0.12, 0.10, 0.08]

AGE_BANDS = ['18-24', '25-34', '35-44', '45-54', '55+']
AGE_WEIGHTS = [0.15, 0.35, 0.25, 0.15, 0.10]

CHANNELS = ['organic', 'paid_search', 'paid_social', 'referral', 'email']
CHANNEL_WEIGHTS = [0.30, 0.25, 0.20, 0.15, 0.10]

EMPLOYMENT = ['employed', 'self_employed', 'student', 'retired', 'unemployed']
EMPLOYMENT_WEIGHTS = [0.55, 0.20, 0.10, 0.10, 0.05]

# ── generate customers ────────────────────────────────────────────────────────

print("Generating customers...")
customers = []
customer_ids = []

for i in range(N_CUSTOMERS):
    customer_id = random_id('cust', i)
    customer_ids.append(customer_id)
    signup_date = random_date(START_DATE, END_DATE)

    customers.append({
        'customer_id': customer_id,
        'first_name': f"First_{i}",
        'last_name': f"Last_{i}",
        'email': f"user_{i}@example.com",
        'country': random.choices(COUNTRIES, COUNTRY_WEIGHTS)[0],
        'age_band': random.choices(AGE_BANDS, AGE_WEIGHTS)[0],
        'acquisition_channel': random.choices(CHANNELS, CHANNEL_WEIGHTS)[0],
        'employment_status': random.choices(EMPLOYMENT, EMPLOYMENT_WEIGHTS)[0],
        'signup_date': signup_date,
        'is_active': random.choices(['true', 'false'], [0.85, 0.15])[0],
        'created_at': signup_date,
        'updated_at': signup_date,
    })

write_csv('customers.csv', list(customers[0].keys()), customers)

# ── generate applications ─────────────────────────────────────────────────────

print("Generating applications...")
applications = []
approved_customers = []

for customer in customers:
    if random.random() > 0.80:
        continue

    customer_id = customer['customer_id']
    signup_date = customer['signup_date']
    applied_at = signup_date + timedelta(days=random.randint(1, 30))

    if applied_at > END_DATE:
        continue

    application_id = random_id('app', len(applications))
    credit_check_at = applied_at + timedelta(hours=random.randint(1, 24))

    approval_rates = {
        'employed': 0.75,
        'self_employed': 0.60,
        'student': 0.40,
        'retired': 0.70,
        'unemployed': 0.20,
    }
    approval_rate = approval_rates.get(customer['employment_status'], 0.60)
    decision = 'approved' if random.random() < approval_rate else 'rejected'

    decided_at = credit_check_at + timedelta(hours=random.randint(1, 48))
    card_issued_at = None

    if decision == 'approved':
        card_issued_at = decided_at + timedelta(days=random.randint(3, 7))
        approved_customers.append({
            'customer_id': customer_id,
            'card_issued_at': card_issued_at,
            'application_id': application_id,
        })

    applications.append({
        'application_id': application_id,
        'customer_id': customer_id,
        'applied_at': applied_at,
        'credit_check_at': credit_check_at,
        'decision': decision,
        'decided_at': decided_at,
        'card_issued_at': card_issued_at,
        'requested_credit_limit': random.choice([500, 1000, 1500, 2000, 3000, 5000]),
        'approved_credit_limit': random.choice([500, 1000, 1500, 2000]) if decision == 'approved' else None,
        'created_at': applied_at,
        'updated_at': decided_at,
    })

write_csv('applications.csv', list(applications[0].keys()), applications)
print(f"Approved customers: {len(approved_customers)}")

# ── generate transactions ─────────────────────────────────────────────────────

print("Generating transactions...")
transactions = []

MERCHANT_CATEGORIES = ['groceries', 'dining', 'transport', 'entertainment',
                        'shopping', 'utilities', 'travel', 'health']
CATEGORY_WEIGHTS = [0.25, 0.20, 0.15, 0.10, 0.12, 0.08, 0.05, 0.05]

STATUSES = ['completed', 'pending', 'failed', 'refunded']
STATUS_WEIGHTS = [0.88, 0.05, 0.04, 0.03]

for approved in approved_customers:
    customer_id = approved['customer_id']
    card_issued_at = approved['card_issued_at']

    if card_issued_at is None:
        continue

    card_issued_date = (card_issued_at if isinstance(card_issued_at, date)
                        else card_issued_at.date())

    if card_issued_date >= END_DATE:
        continue

    n_transactions = random.randint(5, 50)

    for j in range(n_transactions):
        transaction_date = random_date(card_issued_date, END_DATE)
        amount = round(random.uniform(2.50, 500.00), 2)
        category = random.choices(MERCHANT_CATEGORIES, CATEGORY_WEIGHTS)[0]
        status = random.choices(STATUSES, STATUS_WEIGHTS)[0]

        transactions.append({
            'transaction_id': random_id('txn', len(transactions)),
            'customer_id': customer_id,
            'application_id': approved['application_id'],
            'amount': amount,
            'currency': 'GBP',
            'merchant_category': category,
            'transaction_date': transaction_date,
            'status': status,
            'created_at': transaction_date,
            'updated_at': transaction_date,
        })

write_csv('transactions.csv', list(transactions[0].keys()), transactions)

# ── generate credit limit history ─────────────────────────────────────────────

print("Generating credit limit history...")
credit_limit_history = []

for approved in approved_customers:
    customer_id = approved['customer_id']
    card_issued_at = approved['card_issued_at']

    if card_issued_at is None:
        continue

    card_issued_date = (card_issued_at if isinstance(card_issued_at, date)
                        else card_issued_at.date())

    if card_issued_date >= END_DATE:
        continue

    current_limit = random.choice([500, 1000, 1500, 2000])
    valid_from = card_issued_date

    credit_limit_history.append({
        'history_id': random_id('clh', len(credit_limit_history)),
        'customer_id': customer_id,
        'credit_limit': current_limit,
        'change_reason': 'initial_approval',
        'valid_from': valid_from,
        'updated_at': valid_from,
    })

    if random.random() < 0.30:
        change_date = valid_from + timedelta(days=random.randint(90, 365))
        if change_date <= END_DATE:
            new_limit = random.choice([1000, 1500, 2000, 3000, 5000])
            credit_limit_history.append({
                'history_id': random_id('clh', len(credit_limit_history)),
                'customer_id': customer_id,
                'credit_limit': new_limit,
                'change_reason': random.choice([
                    'good_standing',
                    'requested_increase',
                    'annual_review'
                ]),
                'valid_from': change_date,
                'updated_at': change_date,
            })

write_csv('credit_limit_history.csv', list(credit_limit_history[0].keys()),
          credit_limit_history)

print("\nAll done! Files generated:")
print("  - customers.csv")
print("  - applications.csv")
print("  - transactions.csv")
print("  - credit_limit_history.csv")