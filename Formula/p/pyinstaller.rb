class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/21/a7/f3caf846fcba1a840074b843e948272393f4458e9a709a511ce7e43e8ed5/pyinstaller-5.13.1.tar.gz"
  sha256 "a2e7a1d76a7ac26f1db849d691a374f2048b0e204233028d25d79a90ecd1fec8"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50af0b5e850ba61c14811a48cfa3184b58a4becc67eb6377345e716ff66947b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2203bd4c0fcb6ba3e9c5bb3e425e79a0c20dd43c179235e2f96f663e842260e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2c3243a8eb8f63a023152b6609742b2d45e0db666084092860e48e9ab5a0413"
    sha256 cellar: :any_skip_relocation, ventura:        "a4e8c506a49e724aedd2b774290e2f43dd2c024084ac957101ca69be20dcc3ba"
    sha256 cellar: :any_skip_relocation, monterey:       "ec6848a03f08d1ea57b407b7d42ea89b0a2764ab49432a3dcea00ddd72414876"
    sha256 cellar: :any_skip_relocation, big_sur:        "31616f14a2a3f649e496d08b179bb15b87ebe258d1041af74a601ff8453ef794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6792cb0a19a90a94a9b2dbb6f83906798fcdce8b3335e64ea6c85842d1658f7d"
  end

  depends_on "python@3.11"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/5a/13/a7cfa43856a7b8e4894848ec8f71cd9e1ac461e51802391a3e2101c60ed6/altgraph-0.17.3.tar.gz"
    sha256 "ad33358114df7c9416cdb8fa1eaa5852166c505118717021c6a8c7c7abbd03dd"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/46/92/bffe4576b383f20995ffb15edccf1c97d2e39f9a8c72136836407f099277/macholib-1.16.2.tar.gz"
    sha256 "557bbfa1bb255c20e9abafe7ed6cd8046b48d9525db2f9b77d3122a63a2a8bf8"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/38/81/d81344cc66ecb19c15d0b858598347fc0541278c241a96669543fb7519f6/pyinstaller-hooks-contrib-2023.7.tar.gz"
    sha256 "0c436a4c3506020e34116a8a7ddfd854c1ad6ddca9a8cd84500bd6e69c9e68f9"
  end

  def install
    cd "bootloader" do
      system "python3.11", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    virtualenv_install_with_resources
  end

  test do
    (testpath/"easy_install.py").write <<~EOS
      """Run the EasyInstall command"""

      if __name__ == '__main__':
          from setuptools.command.easy_install import main
          main()
    EOS
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build",
                              "#{testpath}/easy_install.py"
    assert_predicate testpath/"dist/easy_install", :exist?
  end
end
