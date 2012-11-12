require "spec_helper"
require "board"

describe Board do
  subject { Board.new }

  describe "#score_board" do
    it "is zero with a blank board for the player" do
      subject.score_board(:player).should == 0
    end

    it "is zero with a blank board for the opponent" do
      subject.score_board(:opponent).should == 0
    end

    it "is 1 when a square has been captured for that color" do
      subject.capture_square(1,4,:player)
      subject.score_board(:player).should == 1
    end

    it "is 0 when a square has been captured for the other color" do
      subject.capture_square(1,4,:player)
      subject.score_board(:opponent).should == 0
    end
  end
end
