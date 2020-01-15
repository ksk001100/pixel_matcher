RSpec.describe PixelMatcher do
  it "has a version number" do
    expect(PixelMatcher::VERSION).not_to be nil
  end

  describe PixelMatcher::DiffImage do
    let(:file1_path) { 'spec/fixtures/images/lena1.png' }
    let(:file2_path) { 'spec/fixtures/images/lena2.png' }
    let(:output_path) { './output.png' }

    subject { PixelMatcher::DiffImage.from_path(file1_path, file2_path) }

    it '#from_path' do
      subject { PixelMatcher::DiffImage.from_path(file1_path, file2_path) }
      expect(subject).to eq subject
    end

    it '#from_blob' do
      subject { PixelMatcher::DiffImage.from_blob(File.read(file_path1), File.read(file_path2)) }
      expect(subject).to eq subject
    end

    it '#export mode only' do
      expect(subject.export(output_path, mode: :only)).to eq subject
      FileUtils.rm_rf(output_path)
    end

    it '#export mode gray scale' do
      expect(subject.export(output_path, mode: :gray_scale)).to eq subject
      FileUtils.rm_rf(output_path)
    end

    it '#export mode compare' do
      expect(subject.export(output_path, mode: :compare)).to eq subject
      FileUtils.rm_rf(output_path)
    end
  end
end
