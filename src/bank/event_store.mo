import types "./types";
import Array "mo:base/Array";
import AccountManager "./account_manager";
import Time "mo:base/Time";
import Nat "mo:base/Nat";
import Float "mo:base/Float";

class EventStore(accountManager: AccountManager.AccountManager) {
  type Account = types.Account;
  type Event = types.Event;
  type EventType = types.EventType;
  var eventStore : [Event] = [];

  public func addEvent(account: Account,  eventType: EventType) : () {
    switch(eventType){
      case (#accountCreated accountCreated) accountCreatedHandler(accountCreated);
      case (#depositDone amount) depositDoneHandler(account, amount);
      case (#withdrawDone amount) withdrawDoneHandler(account, amount);
      case (#fidelityRefundDone amount) fidelityRefundDoneHandler(account, amount);
    }
  };

  //Event Handlers
  func accountCreatedHandler(account:Account) : () {
    let accountCreated = {eventType = #accountCreated account; accountNumber = account.accountNumber; timestamp = Time.now();};
    eventStore := Array.append(eventStore, [accountCreated]);
    accountManager.addAccount(account);
  };

  func depositDoneHandler(account: Account, amount: Float) {
    let depositDone = {eventType = #depositDone amount; accountNumber = account.accountNumber; timestamp = Time.now();};
    eventStore := Array.append(eventStore, [depositDone]);
    accountManager.deposit(account.accountNumber, amount);    
  };

  func withdrawDoneHandler(account: Account, amount: Float) {
    let withdrawDone = {eventType = #withdrawDone amount; accountNumber = account.accountNumber; timestamp = Time.now();};
    eventStore := Array.append(eventStore, [withdrawDone]);
    accountManager.withdraw(account.accountNumber, amount);
    if (amount*0.01 >= 0.01) {
        let refundAmount = amount*0.01;
        addEvent(account, #fidelityRefundDone refundAmount);
    };
  };

  func fidelityRefundDoneHandler(account: Account, amount: Float) {
    let fidelityRefund = {eventType = #fidelityRefundDone amount; accountNumber = account.accountNumber; timestamp = Time.now();};
    eventStore := Array.append(eventStore, [fidelityRefund]);
    accountManager.deposit(account.accountNumber, amount);    
  };


  public func getAllEvents() : [Event] {
    return eventStore
  };


};
