from abc import ABC, abstractmethod


class Provider(ABC):
    name: str = ""

    @abstractmethod
    async def search(self, query: str) -> list[dict]:
        raise NotImplementedError

    async def details(self, provider_id: str) -> dict | None:
        return None

    async def sources(self, provider_id: str) -> list[dict]:
        return []