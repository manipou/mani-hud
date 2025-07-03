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
    CrossingRoad: string;
    ServerLogo: string;
    PlayerCount: number;
    PlayerData: {
        Job: string;
        Grade: string;
        Money: number;
        BlackMoney: number;
        Bank: number;
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
    SpeedUnit: "KM/h",
    Heading: 0,
    StreetName: "",
    CrossingRoad: "",
    ServerLogo: "",
    PlayerCount: 0,
    PlayerData: {
        Job: "",
        Grade: "",
        Money: 0,
        BlackMoney: 0,
        Bank: 0
    }
});