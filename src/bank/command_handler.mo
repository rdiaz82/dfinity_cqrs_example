import EventStore "./event_store";
import Float "mo:base/Float";
import types "./types";
import AccountManager "./account_manager";

class CommandHandler(eventStore: EventStore.EventStore, accountManager: AccountManager.AccountManager) {
  type Account = types.Account;
  type Event = types.Event;
  type EventType = types.EventType;


  public func addAccount(account: Account): () {
    eventStore.addEvent(account, #accountCreated account);
  };

  public func deposit(accountNumber: Nat, amount: Float): () {
    let account = accountManager.getAccount(accountNumber);
        switch (account) {
            case(?accountExists) {  eventStore.addEvent(accountExists, #depositDone amount); };
            case(null) {};
        };
  };

   public func withdraw(accountNumber: Nat, amount: Float): Bool {
     let account = accountManager.getAccount(accountNumber);
        switch (account) {
            case(?accountExists) {  
              if (accountExists.balance < amount) return false;
              eventStore.addEvent(accountExists, #withdrawDone amount);
              return true;
            };
            case(null) {return false; };
        };
  };

};