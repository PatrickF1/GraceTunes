require "test_helper"

class MusicTest < ActiveSupport::TestCase

  test "checking if note is flat" do
    assert Music::flat?("Ab")
    assert_not Music::flat?("C")
    assert_not Music::flat?("F#")
  end

  test "checking if note is sharp" do
    assert Music::sharp?("C#")
    assert_not Music::sharp?("E")
    assert_not Music::sharp?("Bb")
  end

  test "checking if note is natural" do
    assert Music::natural?("A")
    assert_not Music::natural?("Bb")
    assert_not Music::natural?("C#")
  end

  test "checking if a note a number" do
    assert Music::number?("I")
    assert Music::number?("iv")
    assert Music::number?("VII")
    assert_not Music::number?("A")
    assert_not Music::number?("C#")
    assert_not Music::number?("fjkslfjds")
  end

  test "sharpening note" do
    assert_equal "A#", Music::sharpen("A")
    assert_equal "B", Music::sharpen("A#")
    assert_equal "D", Music::sharpen("C#")
    assert_equal "F", Music::sharpen("Fb")
    assert_equal "A", Music::sharpen("G#")
    assert_equal "II#", Music::sharpen("II")
    assert_equal "vi#", Music::sharpen("vi")
  end

  test "flattening note" do
    assert_equal "Bb", Music::flatten("B")
    assert_equal "A", Music::flatten("Bb")
    assert_equal "C", Music::flatten("C#")
    assert_equal "C", Music::flatten("Db")
    assert_equal "Ab", Music::flatten("A")
    assert_equal "E", Music::flatten("E#")
    assert_equal "IIIb", Music::flatten("III")
    assert_equal "viib", Music::flatten("vii")
  end

  test "checking if first note is sharpen than second note" do
    assert Music::sharper?("C#", "C")
    assert Music::sharper?("C", "Cb")
    assert Music::sharper?("C#", "Cb")
    assert_not Music::sharper?("C", "C#")
    assert_not Music::sharper?("Cb", "C#")
    assert_not Music::sharper?("Cb", "C")
  end

  test "checking if first note is flatter than second note" do
    assert Music::flatter?("C", "C#")
    assert Music::flatter?("Cb", "C#")
    assert Music::flatter?("Cb", "C")
    assert_not Music::flatter?("C#", "C")
    assert_not Music::flatter?("C", "Cb")
    assert_not Music::flatter?("C#", "Cb")
  end

  test "getting natural version of note" do
    assert_equal "A", Music::get_natural("A#")
    assert_equal "A", Music::get_natural("Ab")
    assert_equal "A", Music::get_natural("A")
  end

end