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

  describe "#update_concreteness" do
    it "doesn't concrete anything when the board is fresh" do
      subject.update_concreteness
      subject.should_not_receive :concrete
    end

    it "concretes the top left corner when the three tiles are taken" do
      subject.capture_square(0,0,:player)
      subject.capture_square(0,1,:player)
      subject.capture_square(1,0,:player)
      subject.update_concreteness
      subject.cell(0,0)[:concrete].should be_true
    end

    it "concretes the top right corner when the three tiles are taken" do
      subject.capture_square(4,0,:player)
      subject.capture_square(3,0,:player)
      subject.capture_square(4,1,:player)
      subject.update_concreteness
      subject.cell(4,0)[:concrete].should be_true
    end

    it "concretes the bottom left corner when the three tiles are taken" do
      subject.capture_square(0,4,:player)
      subject.capture_square(1,4,:player)
      subject.capture_square(0,3,:player)
      subject.update_concreteness
      subject.cell(0,4)[:concrete].should be_true
    end

    it "concretes the bottom right corner when the three tiles are taken" do
      subject.capture_square(4,4,:player)
      subject.capture_square(3,4,:player)
      subject.capture_square(4,3,:player)
      subject.update_concreteness
      subject.cell(4,4)[:concrete].should be_true
    end

    it "doesn't concrete a cell which is surrounded but not captured" do
      subject.capture_square(2,2,:player)
      subject.capture_square(3,3,:player)
      subject.capture_square(1,3,:player)
      subject.capture_square(2,4,:player)
      subject.update_concreteness
      subject.cell(2,3)[:concrete].should be_false
    end

    it "concretes a cell on the top edge with the three surrounding cells captured" do
      subject.capture_square(2,0,:player)
      subject.capture_square(1,0,:player)
      subject.capture_square(3,0,:player)
      subject.capture_square(2,1,:player)
      subject.update_concreteness
      subject.cell(2,0)[:concrete].should be_true
    end

    it "concretes a cell on the bottom edge with the three surrounding cells captured" do
      subject.capture_square(2,4,:player)
      subject.capture_square(1,4,:player)
      subject.capture_square(3,4,:player)
      subject.capture_square(2,3,:player)
      subject.update_concreteness
      subject.cell(2,4)[:concrete].should be_true
    end

    it "concretes a cell on the left edge with the three surrounding cells captured" do
      subject.capture_square(0,2,:player)
      subject.capture_square(0,1,:player)
      subject.capture_square(0,3,:player)
      subject.capture_square(1,2,:player)
      subject.update_concreteness
      subject.cell(0,2)[:concrete].should be_true
    end

    it "concretes a cell on the right edge with the three surrounding cells captured" do
      subject.capture_square(4,2,:player)
      subject.capture_square(4,1,:player)
      subject.capture_square(4,3,:player)
      subject.capture_square(3,2,:player)
      subject.update_concreteness
      subject.cell(4,2)[:concrete].should be_true
    end

    it "concretes a cell when it's captured and all 4 cells surround it" do
      subject.capture_square(2,2,:player)
      subject.capture_square(2,3,:player)
      subject.capture_square(3,2,:player)
      subject.capture_square(1,2,:player)
      subject.capture_square(2,1,:player)
      subject.update_concreteness
      subject.cell(2,2)[:concrete].should be_true
    end
  end
end
