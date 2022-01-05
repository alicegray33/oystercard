require 'oystercard'

describe Oystercard do

  let(:entry_station){ double :station }
  let(:exit_station){ double :station }
  let(:journey){ {entry_station: entry_station, exit_station: exit_station} }

  it 'starts with a balance of zero' do
    expect(subject.balance).to eq (0)
  end
  it 'is initially not in a journey' do
    expect(subject).not_to be_in_journey
  end
  it 'has an empty list of journeys by default' do
    expect(subject.journeys).to be_empty
  end
  
  context 'topped up and touched in:' do
    before do
      subject.top_up(Oystercard::MINIMUM_BALANCE)
      subject.touch_in(entry_station)
    end
    it 'stores the starting station' do
      expect(subject.journeys).to include( { entry_station: entry_station } )
    end
    it 'stores the exit station' do
      subject.touch_out(exit_station)
      expect(subject.journeys).to include( { exit_station: exit_station } )
    end
  end

  it 'can top up the balance' do
    expect{ subject.top_up 1 }.to change{ subject.balance }.by 1
  end

  context 'has maximum balance:' do
    before(:each) do
      @maximum_balance = Oystercard::MAXIMUM_BALANCE
      subject.top_up(@maximum_balance)
    end 
    it 'raises an error if the maximun balance is exceeded' do
      expect{ subject.top_up 1 }.to raise_error "Maximum balance of #{@maximum_balance} exceeded"
    end
  end

  context 'loaded with minumum balance and touched in:' do
    before do
      subject.top_up(Oystercard::MINIMUM_BALANCE)
      subject.touch_in(entry_station)
    end
    it 'can be in a journey' do
      expect(subject).to be_in_journey
    end
    it 'can touch out' do
      subject.touch_out(exit_station)
      expect(subject).not_to be_in_journey
    end
    it 'will deduct the correct fare at end of journey' do      
      expect { subject.touch_out(exit_station) }.to change{ subject.balance }.by(-Oystercard::MINIMUM_BALANCE)
    end
    it 'stores a journey' do
      subject.touch_out(exit_station)
      expect(subject.journeys).to include journey
    end  
  end
  
  it 'raises an error if below minimum balance' do
    @minimum_balance = Oystercard::MINIMUM_BALANCE
    expect{ subject.touch_in(entry_station) }.to raise_error "Minimum balance of #{@minimum_balance} required to touch in"
  end

end
