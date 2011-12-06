require 'spec_helper'

describe ZipReplacer do
  it "should be created" do
    zr = ZipReplacer.new
  end

  it "should scan placeholders" do
    zr = ZipReplacer.new
    r = zr.scan('./zx_template/ZxTemplate.xlsx')
    (r == ['address','name']).should be_true
  end

  it "should replace placeholders" do
    zr = ZipReplacer.new
    zip_dir, count = zr.replace('./zx_template/ZxTemplate.xlsx', {'name' => 'CHUBACHI', 'address' => 'SHINAGAWA'})

    zip_dir.should_not be_blank
    count.should_not be_zero
  end
end
