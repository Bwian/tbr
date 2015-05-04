describe 'Logging' do
  
  before :each do
    FileUtils.rm_f(LOGFILE)
  end
  
  it "should log to a file" do
    Tbr.log = LOGFILE
    Tbr.log.warn('Danger!')
    expect(check_file(LOGFILE)).to be_truthy
  end
  
  it "shouldn't log by default" do
    Tbr.log.warn('Danger!')
    expect(check_file(LOGFILE)).to be_falsy
  end
  
  it "shouldn't log to a file" do
    Tbr.log = nil
    Tbr.log.warn('Danger!')
    expect(check_file(LOGFILE)).to be_falsy
  end
  
  private
  
  def check_file(fname)
    begin
      size = File.open(fname).size
		rescue Errno::ENOENT
      return false 
    end
    size > 0 
  end
end