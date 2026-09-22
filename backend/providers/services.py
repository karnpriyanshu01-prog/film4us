import asyncio

from .registry import PROVIDERS


async def search_all(query: str) -> list[dict]:
    tasks = [
        provider.search(query)
        for provider in PROVIDERS
    ]

    results = await asyncio.gather(
        *tasks,
        return_exceptions=True,
    )

    combined = []

    for result in results:
        if isinstance(result, Exception):
            continue

        combined.extend(result)

    return combined