import H "mo:base/HashMap";
import Hash "mo:base/Hash";
import types "./types";

class AccountManager() {
  type Account = types.Account;

  let eq: (Nat,Nat) ->Bool = func(x, y) { x == y };
  let accounts = H.HashMap<Nat, Account>(8, eq, Hash.hash);

  public func addAccount(account: Account) : () {  
    accounts.put(account.accountNumber, account);
  }; 

  public func deposit(accountNumber: Nat,  amount: Float) : () {  
    switch(accounts.get(accountNumber)) {
        case(?existingEntry) {
          let newBalance = existingEntry.balance + amount;
          accounts.put(accountNumber, { accountNumber = existingEntry.accountNumber; name = existingEntry.name; surname = existingEntry.surname; balance = newBalance; });
        };
        case(null) { 
            /* do something if it doesn't find an entry in the hashmap */
        };
    };
  }; 

  public func withdraw(accountNumber: Nat,  amount: Float) : () {  
    switch(accounts.get(accountNumber)) {
        case(?existingEntry) {
          let newBalance = existingEntry.balance - amount;
          accounts.put(accountNumber, { accountNumber = existingEntry.accountNumber; name = existingEntry.name; surname = existingEntry.surname; balance = newBalance; });
        };
        case(null) { 
            /* do something if it doesn't find an entry in the hashmap */
        };
    };
  }; 


  public func getAccount(account: Nat) : ?Account {
    return accounts.get(account);
  };

};