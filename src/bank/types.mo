import Time "mo:base/Time";

type Account = {
  accountNumber : Nat;
  name : Text;
  surname : Text;
  balance : Float;
};

type EventType = { #accountCreated: Account; #depositDone: Float; #withdrawDone: Float; #fidelityRefundDone: Float; };

type Event = {
  eventType : EventType;
  accountNumber : Nat;
  timestamp: Time.Time;
};