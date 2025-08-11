import { writable } from "svelte/store";
import { isEnvBrowser } from "$lib/utils/misc";

const visibility = writable(isEnvBrowser());

export const visibilityStore = {
	subscribe: visibility.subscribe,
	show: () => visibility.set(true),
	hide: () => visibility.set(false),
	toggle: (value?: boolean) =>
		visibility.update((v) => (value !== undefined ? value : !v)),
};

export const Hud = writable<{
    Showing: boolean;
	ShowCompass: boolean;
    Health: number;
    Armor: number;
    Hunger: number;
    Thirst: number;
    HasWeapon: boolean;
    Weapon: string;
    Ammo: number;
    MaxAmmo: number;
    InVehicle: boolean;
	Speed: number;
    Fuel: number;
    SpeedUnit: string;
    Heading: number;
    StreetName: string;
    Zone: string;
    ServerLogo: string;
    PlayerCount: number;
    Id: number;
    Talking: boolean;
    VoiceRange: number;
    AspectRatio: number;
    Currency: {
        Symbol: string;
        Position: string;
        Separator: string;
    }
    PlayerData: {
        Job: string;
        Grade: string;
        Money: number;
        BlackMoney: number;
        Bank: number;
    }
    HudSettings: {
        ShowMenu: boolean;
        ShowCompass: string;
        Stats: string;
		ServerInfo: string;
		CompassMode: string;
        CompassInterval: string;
        Offsets: {
            ServerInfo: { X: number; Y: number };
            [key: string]: { X: number; Y: number };
        };
    }
}>({
    Showing: true,
	ShowCompass: true,
    Health: 100,
    Armor: 0,
	Hunger: 100,
	Thirst: 100,
    HasWeapon: false,
    Weapon: "",
    Ammo: 0,
    MaxAmmo: 0,
    InVehicle: false,
	Speed: 0,
    Fuel: 100,
    SpeedUnit: "km/h",
    Heading: 0,
    StreetName: "",
    Zone: "",
    ServerLogo: "",
    PlayerCount: 0,
    Id: 0,
    Talking: false,
    VoiceRange: 1,
    AspectRatio: 1.7777777910233,
    Currency: {
        Symbol: " kr.",
        Position: "after",
        Separator: ","
    },
    PlayerData: {
        Job: "",
        Grade: "",
        Money: 0,
        BlackMoney: 0,
        Bank: 0
    },
    HudSettings: {
        ShowMenu: false,
        ShowCompass: "on",
		Stats: "A",
		ServerInfo: "A",
		CompassMode: "Camera",
        CompassInterval: "Low",
        Offsets: {
            ServerInfo: { X: 0, Y: 0 }
        }
    }
});