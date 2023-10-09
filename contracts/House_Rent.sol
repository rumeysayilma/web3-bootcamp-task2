// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

contract KiralamaSozlesmesi {
    address public sahibi;
    uint256 public kiraBaslangicTarihi;
    uint256 public kiraBitisTarihi;
    uint256 public kiraMiktari;
    bool public kirayaVerildi;

    address public kiraci;
    string public kiraciAdi;
    string public kiraciAdresi;

    uint256 public tarihUnixZamanDamgasi;

    enum Durum { Beklemede, Kiralandi, Sonlandirildi }
    Durum public durum;

    event Kiralandi();
    event Sonlandirildi();
    event HataBildirildi(string hataMesaji);

    constructor(uint256 _kiraBaslangicYili, uint256 _kiraBitisYili, uint256 _kiraMiktari) {
        sahibi = msg.sender;
        kiraBaslangicTarihi = _kiraBaslangicYili;
        kiraBitisTarihi = _kiraBitisYili;
        kiraMiktari = _kiraMiktari;
        kirayaVerildi = false;
        durum = Durum.Beklemede;

    }

    modifier sadeceSahibi() {
        require(msg.sender == sahibi, "This must be done by the owner.");
        _;
    }

    modifier sadeceKiraci() {
        require(msg.sender == kiraci, "This process must be done by the tenant.");
        _;
    }

    modifier kiralanabilirDurum() {
        require(durum == Durum.Beklemede, "It is not rentable.");
        _;
    }

    modifier sonlandirilabilirDurum() {
        require(durum == Durum.Kiralandi, "It cannot be terminated.");
        _;
    }



    function kirayaVer(string memory _kiraciAdi, string memory _kiraciAdresi) public sadeceSahibi kiralanabilirDurum {
        kiraci = msg.sender;
        kiraciAdi = _kiraciAdi;
        kiraciAdresi = _kiraciAdresi;
        kirayaVerildi = true;
        durum = Durum.Kiralandi;
        emit Kiralandi();
    }

    function kiraSonlandir() public sadeceSahibi sonlandirilabilirDurum {
        durum = Durum.Sonlandirildi;
        kirayaVerildi = false;
        kiraci = address(0);
        delete kiraciAdi;
        delete kiraciAdresi;
        emit Sonlandirildi();
    }

    function hataBildir(string memory hataMesaji) public sadeceKiraci {
        // Kiracı tarafından bildirilen hata mesajını kaydedebilir ve gerekirse işlem yapabilir.
        emit HataBildirildi(hataMesaji);
    }


}
