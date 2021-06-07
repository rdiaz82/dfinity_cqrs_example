import AccountManager "./account_manager";
import EventStore "./event_store";
import types "./types";
import Array "mo:base/Array"


class Readmodels(eventStore: EventStore.EventStore, accountManager: AccountManager.AccountManager) {
  type Account = types.Account;
  type Event = types.Event;

  public func getAccount(accountNumber: Nat): ?Account {
    return accountManager.getAccount(accountNumber);
  };

  public func getAllLedgers(): [Event] {
    return eventStore.getAllEvents();
  };

  public func getAccountLedger(accountNumber: Nat): [Event] {
    return Array.filter<Event>(eventStore.getAllEvents(), func (event: Event) { event.accountNumber == accountNumber; });
  };

  public func getTotalFidelityRefundForAccount(accountNumber: Nat): Float {
    return Array.foldLeft<Event, Float>(getAccountLedger(accountNumber), 0.0, func (partialAmount: Float, event: Event) {
      switch (event.eventType) {
        case(#fidelityRefundDone amount) return amount + partialAmount;
        case (_)  return partialAmount;
      };
    });
  }
};