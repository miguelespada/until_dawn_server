class User
  include Mongoid::Document
  field :name, type: String, :default => "NEW PLAYER"
  field :male, type: Boolean, :default => true
  field :active, type: Boolean, :default => false
  field :indice, type: Integer, :default => 0
  field :runningTime, type: Integer, :default => 0
  field :flow, type: Array
  field :thermal, type: Array
  field :temp, type: Array
  field :conductance, type: Array
  field :galvanicVoltage, type: Array
  field :heartRate, type: Array
  field :stress, type: Array
end