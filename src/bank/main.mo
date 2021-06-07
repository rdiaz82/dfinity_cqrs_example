import AccountManager "./account_manager";
import CommandHandler "./command_handler";
import EventStore "./event_store";
import Readmodels "./read_models";
import types "./types";

actor {
    type Account = types.Account;
    type Event = types.Event;
    let accountManager = AccountManager.AccountManager();
    let eventStore = EventStore.EventStore(accountManager);
    let commandHandler = CommandHandler.CommandHandler(eventStore, accountManager);
    let readmodels = Readmodels.Readmodels(eventStore, accountManager);

// COMMANDS    
    public func createAccount(accountNumber: Nat, name : Text, surname: Text) : () {
        let account = { accountNumber = accountNumber; name = name; surname = surname; balance = 0.0;};
        commandHandler.addAccount(account);
    };

    public func deposit(accountNumber: Nat, amount: Float) : async () {
        commandHandler.deposit(accountNumber, amount: Float);
    };

    public func withdraw(accountNumber: Nat, amount: Float) : async Bool {
        return commandHandler.withdraw(accountNumber, amount);
    };

// READMODELS
    public func getAccount(accountNumber: Nat): async ?Account {
        return readmodels.getAccount(accountNumber);
    };

    public func getAllLedgers(): async [Event] {
        return readmodels.getAllLedgers();
    };

    public func getAccountLedger(accountNumber: Nat): async [Event] {
        return readmodels.getAccountLedger(accountNumber);
    };

    public func getTotalFidelityRefundForAccount(accountNumber: Nat): async Float {
        return readmodels.getTotalFidelityRefundForAccount(accountNumber);
    }


};