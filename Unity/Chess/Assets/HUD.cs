using System.Collections;
using UnityEngine;
using UnityEngine.UI;

public class HUD : MonoBehaviour {
    public Text textbox;
    public Image banner;

    public bool show = true;

    public string bannerText;

    void Start() {
        bannerText = "Beginn!";
    }

    void Update() {
        textbox.text = bannerText;
    }

    public void hideHUD() {
        textbox.enabled = false;
        banner.enabled = false;
        show = false;
    }

    public void showHUD() {
        textbox.enabled = true;
        banner.enabled = true;
        show = true;
    }
}