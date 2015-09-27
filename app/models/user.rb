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

  field :max_temp, type: Integer, :default => 3000
  field :min_temp, type: Integer, :default => 5000

  def update_temp t
    t = t.to_f
    self.temp << t
    self.temp.shift if self.temp.count > 1200
    self.max_temp = t if t > self.max_temp
    self.min_temp = t if t < self.min_temp
  rescue
  end
end