def MergeSort(UnsortedTags):

    import TagClass as TagClass

    for i, l in enumerate(UnsortedTags):
            UnsortedTags[i].CalculateNet()

    if len(UnsortedTags) > 1:
        mid = len(UnsortedTags) // 2
        left = UnsortedTags[:mid]
        right = UnsortedTags[mid:]

        MergeSort(left)
        MergeSort(right)

        i = 0
        j = 0
        k = 0

        while i < len(left) and j < len(right):
            if left[i].GetTime() >= right[j].GetTime():
                UnsortedTags[k] = left[i]
                i += 1
            else:
                UnsortedTags[k] = right[j]
                j += 1
            k += 1

        while i < len(left):
            UnsortedTags[k] = left[i]
            i += 1
            k += 1

        while j < len(right):
            UnsortedTags[k] = right[j]
            j += 1
            k += 1


        for l, q in enumerate(UnsortedTags):
            Position = (l - len(UnsortedTags)) * -1
            UnsortedTags[l].SetRanking(Position)

    return UnsortedTags